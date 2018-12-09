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

public struct WotdEntry {
	public let word: String
	public let date: Date
}

public class Wotd {
	
	// When looking up random words, their "frequency" is a factor in the selection.
	// Words which are too frequent (a, the, why) are not interesting words.
	// Words which are too rare (aalto) are likely not interesting either.
	private static let MIN_INTERESTING_FREQUENCY = 1500
	private static let MAX_INTERESTING_FREQUENCY = 25000
	
	private init() {		
	}
	public class func findRandomWord(context: NSManagedObjectContext, seed: Int64?) -> String {
		do {
			let result: [Stems] = try getWotdFetchResult(context:context)
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
		return getWordOfTheDay(context: context, date: getTodayUTC())
	}
	class func getWordOfTheDay(context: NSManagedObjectContext, date: Date) -> String {
		// https://stackoverflow.com/questions/26189656/how-can-i-set-an-nsdate-object-to-midnight
		var cal = Calendar.current
		if let utc = TimeZone.init(abbreviation: "UTC") {
			cal.timeZone = utc
		}
		let seed = Int64(cal.startOfDay(for: date).timeIntervalSince1970 * 1000)
		return findRandomWord(context: context, seed:seed)
	}
	
	public class func getLastWordsOfTheDay(context: NSManagedObjectContext, count: Int) -> [WotdEntry] {
		var wotdEntries: [WotdEntry] = []

		do {
			var cal = Calendar.current
			if let utc = TimeZone.init(abbreviation: "UTC") {
				cal.timeZone = utc
			}
			let todayUTC = getTodayUTC()

			let stems: [Stems] = try getWotdFetchResult(context: context)
			
			for i in 0..<count {
				if let date = cal.date(byAdding: .day, value: -i, to: todayUTC) {
					let seed = Int64(cal.startOfDay(for: date).timeIntervalSince1970 * 1000)
					let random = Random(inputSeed:seed)
					let randomIndex = random.nextInt(Int64(stems.count))
					if let word = stems[Int(randomIndex)].word {
						let wotdEntry = WotdEntry(word: word, date: date)
						wotdEntries.append(wotdEntry)
					}
				}
			}
		} catch let error {
			print ("Error finding random word: \(error)")
		}
		return wotdEntries
	}
	
	private class func getWotdFetchResult(context: NSManagedObjectContext) throws -> [Stems] {
		let request: NSFetchRequest<Stems> = Stems.fetchRequest()
		request.predicate = NSPredicate(format: "\(#keyPath(Stems.google_ngram_frequency)) > %d AND \(#keyPath(Stems.google_ngram_frequency)) < %d", MIN_INTERESTING_FREQUENCY, MAX_INTERESTING_FREQUENCY)
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Stems.word), ascending: true)]
		return try context.fetch(request)
	}
	
	private class func getTodayUTC() -> Date {
		var now = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
		now.hour = 0
		now.minute = 0
		now.second = 0
		now.nanosecond = 0
		if let utc = TimeZone.init(abbreviation: "UTC") {
			now.timeZone = utc
		}
		return Calendar.current.date(from: now) ?? Date()
	}
}
