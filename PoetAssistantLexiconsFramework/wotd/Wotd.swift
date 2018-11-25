/**
Copyright (c) 2018 Carmen Alvarez

This file is part of Poet Assistant.

Poet Assistant is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Poet Assistant is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Poet Assistant.  If not, see <http://www.gnu.org/licenses/>.
*/
import CoreData
import UserNotifications

public class Wotd {
	
	// When looking up random words, their "frequency" is a factor in the selection.
	// Words which are too frequent (a, the, why) are not interesting words.
	// Words which are too rare (aalto) are likely not interesting either.
	private static let MIN_INTERESTING_FREQUENCY = 1500
	private static let MAX_INTERESTING_FREQUENCY = 25000
	private static let NOTIFICATION_KEY_WOTD = "wotd"
	private static let NOTIFICATION_ID = "1770120-08-743-064"
	
	private init() {
		
	}
	public class func findRandomWord(context: NSManagedObjectContext, seed: Int64?) -> String {
		let request: NSFetchRequest<Stems> = Stems.fetchRequest()
		request.predicate = NSPredicate(format: "\(#keyPath(Stems.google_ngram_frequency)) > %d AND \(#keyPath(Stems.google_ngram_frequency)) < %d", MIN_INTERESTING_FREQUENCY, MAX_INTERESTING_FREQUENCY)
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Stems.word), ascending: true)]
		do {
			let result: [Stems] = try context.fetch(request)
			let random = Random(inputSeed:seed)
			let randomIndex = random.nextInt(Int64(result.count))
			if let word = result[Int(randomIndex)].word {
				return word
			}
		} catch let error {
			print ("Error finding random word: \(error)")
		}
		return "error" // why not
	}
	public class func findRandomWord(context: NSManagedObjectContext) -> String {
		return findRandomWord(context:context, seed:nil)
	}
	public class func getWordOfTheDay(context: NSManagedObjectContext) -> String {
		return getWordOfTheDay(context: context, date: Date())
	}
	class func getWordOfTheDay(context: NSManagedObjectContext, date: Date) -> String {
		// https://stackoverflow.com/questions/26189656/how-can-i-set-an-nsdate-object-to-midnight
		var cal = Calendar(identifier: .gregorian)
		if let utc = TimeZone.init(abbreviation: "UTC") {
			cal.timeZone = utc
		}
		let seed = Int64(cal.startOfDay(for: date).timeIntervalSince1970 * 1000)
		return findRandomWord(context: context, seed:seed)
	}
	public class func disable() {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NOTIFICATION_ID])
		UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:[NOTIFICATION_ID])
	}
	public class func hasNotificationsScheduled(handler: @escaping (Bool) -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {settings in
			if settings.authorizationStatus != .authorized {
				DispatchQueue.main.async {handler(false)}
			} else {
				UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
					DispatchQueue.main.async {handler(requests.count > 0)}
				})
			}
		})
		
	}
	public class func scheduleNotifications() {
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			// Do not schedule notifications if not authorized.
			guard settings.authorizationStatus == .authorized else {return}
			
			if settings.alertSetting == .enabled {
				DispatchQueue.main.async {
					createNotification() { notificationContent in
						//var dateComponents = DateComponents()
						//dateComponents.calendar = Calendar.current
						//let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
						let request = UNNotificationRequest(identifier: NOTIFICATION_ID,
															content: notificationContent,
															trigger: nil)
						UNUserNotificationCenter.current().add(request) { error in
							if error != nil {
								print("notification request error: \(String(describing: error))")
							}
						}
					}
				}
			}
		}
	}
	
	public class func createNotification(completion: @escaping (UNMutableNotificationContent) -> Void){
		CoreDataAccess.persistentDictionariesContainer.performBackgroundTask({context in
			//let wotd = getWordOfTheDay(context: context)
			let content = UNMutableNotificationContent()
			content.title = String(format: NSLocalizedString("wotd_notif_title", comment: ""))
			content.categoryIdentifier = "Wotd"
			//content.userInfo[NOTIFICATION_KEY_WOTD] = wotd
			
			DispatchQueue.main.async {
				completion(content)
			}
		})
	}
	public class func getWotd(notificationResponse: UNNotificationResponse) -> String? {
		return notificationResponse.notification.request.content.userInfo[NOTIFICATION_KEY_WOTD] as? String
	}
}
