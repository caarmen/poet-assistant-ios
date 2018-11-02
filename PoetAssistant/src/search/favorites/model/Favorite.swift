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

class Favorite: NSManagedObject {
	
	class func createFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController<Favorite> {
		let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Favorite.word), ascending: true)]
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}

	class func isFavorite(context: NSManagedObjectContext, word: String) -> Bool {
		let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
		request.predicate = NSPredicate(format: "\(#keyPath(Favorite.word)) =[c] %@", word)
		do {
			return try context.count(for: request) > 0
		} catch let error {
			print("Error checking if \(word) is a favorite: \(error)")
			return false
		}
	}
	class func fetchFavorites(context: NSManagedObjectContext) -> [String] {
		let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
		do {
			return try context.fetch(request).map { $0.word! }
		} catch let error {
			print("Error fetching favorites: \(error)")
			return []
		}
	}

	class func toggleFavorite(word: String) {
		let context = AppDelegate.persistentUserDbContainer.viewContext
		let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
		request.predicate = NSPredicate(format: "\(#keyPath(Favorite.word)) =[c] %@", word)
		do {
			if let existingFavorite = try context.fetch(request).first {
				context.delete(existingFavorite)
			} else {
				let favorite = Favorite(context:context)
				favorite.word = word.lowercased(with: Locale.current)
			}
			try context.save()
		} catch let error {
			print ("Error saving favorite \(word): \(error)")
		}
	}
	
	class func clearFavorites(completion: @escaping (() -> Void)) {
		AppDelegate.persistentUserDbContainer.performBackgroundTask { context in
			do {
				let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
				let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
				try context.execute(deleteRequest)
				try context.save()
				// Core data won't broadcast any notification for the batch delete
				// So let's hack around this by also doing an individual insert
				// followed by an individual delete, so core data will broadcast a
				// notification. I don't want to implement my own additional notification
				// and listeners for this.........
				
				// Add a favorite
				let favorite = Favorite(context:context)
				favorite.word = "poem"
				try context.save()
				
				// Remove the favorite
				context.delete(favorite)
				try context.save()
				
				DispatchQueue.main.async(execute: completion)
			} catch let error {
				print ("Error clearing favorites \(error)")
			}
		}
	}
}
