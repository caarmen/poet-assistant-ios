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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
	
	private func loadContainer(databaseName: String) -> NSPersistentContainer {
		let container = NSPersistentContainer(name: databaseName)
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}
	// MARK: - Core Data Saving support
	
	func saveContext () {
		saveContext(container: persistentEmbeddedDbContainer)
		saveContext(container: persistentUserDbContainer)
	}
	private func saveContext(container: NSPersistentContainer) {
		let context = container.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	static var persistentDictionariesContainer: NSPersistentContainer {
		return (UIApplication.shared.delegate as! AppDelegate).persistentEmbeddedDbContainer
	}
	
	static var persistentUserDbContainer: NSPersistentContainer {
		return (UIApplication.shared.delegate as! AppDelegate).persistentUserDbContainer
	}
}

