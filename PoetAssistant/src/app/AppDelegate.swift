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

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Settings.registerDefaults()
		if CommandLine.arguments.contains("UITesting") {
			Settings.clear()
			Suggestion.clearHistory(completion: nil)
			Favorite.clearFavorites {}
			FileUtils.deleteAllDocuments()
		}
		Settings.getTheme().apply()
		UNUserNotificationCenter.current().delegate = self
		return true
	}

	// MARK: - Core Data stack
	lazy var persistentEmbeddedDbContainer: NSPersistentContainer = {
		EmbeddedDb.install()
		return loadContainer(databaseName: "dictionaries")
	}()
	
	lazy var persistentUserDbContainer: NSPersistentContainer = {
		return loadContainer(databaseName: "userdata")
	}()
	
}
