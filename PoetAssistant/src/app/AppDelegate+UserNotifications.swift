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

import UserNotifications
import UIKit
import PoetAssistantLexiconsFramework

extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler(.alert)
	}
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler:
		@escaping () -> Void) {
		if let wotd = Wotd.getWotd(notificationResponse: response) {
			search(query:wotd)
		}
		completionHandler()
	}
	
	private func search(query: String) {
		var vc = self.window?.rootViewController as? TabBarController
		if vc == nil {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			vc = storyboard.instantiateInitialViewController() as? TabBarController
			if vc != nil {
				self.window = UIWindow(frame: UIScreen.main.bounds)
				self.window?.rootViewController = vc
				self.window?.makeKeyAndVisible()
			}
		}
		vc?.search(query: query)
	}
}
