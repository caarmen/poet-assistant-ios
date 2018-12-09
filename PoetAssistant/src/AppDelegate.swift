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
import PoetAssistantLexiconsFramework

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
		return true
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
			components.host == "query",
			let queryPath = components.path, queryPath.hasPrefix("/") else {
				print("Invalid URL \(url)")
				return false
		}
		if let index = queryPath.lastIndex(of: "/") {
			let queryWord = queryPath.suffix(from: queryPath.index(index, offsetBy: 1))
			search(query: String(queryWord))
			return true
		}
		return false
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

	// MARK: - Core Data stack

	lazy var persistentEmbeddedDbContainer: NSPersistentContainer = {
		return CoreDataAccess.persistentDictionariesContainer
	}()
	
	lazy var persistentUserDbContainer: NSPersistentContainer = {
		return loadContainer(databaseName: "userdata")
	}()
	
	private func loadContainer(databaseName: String) -> NSPersistentContainer {
		let container = NSPersistentContainer(name: databaseName)
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}

	static func search(query: String) {
		(UIApplication.shared.delegate as! AppDelegate).search(query: query)
	}

	static var persistentDictionariesContainer: NSPersistentContainer {
		return (UIApplication.shared.delegate as! AppDelegate).persistentEmbeddedDbContainer
	}
	
	static var persistentUserDbContainer: NSPersistentContainer {
		return (UIApplication.shared.delegate as! AppDelegate).persistentUserDbContainer
	}
}
