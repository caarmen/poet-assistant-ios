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

class Suggestion: NSManagedObject {
	class func createSearchSuggestionsFetchResultsController(queryText: String?) -> SuggestionsFetchedResultsControllerWrapper {
		return SuggestionsFetchedResultsControllerWrapper(queryText:queryText)
	}
	
	class func createHistorySearchSuggestionsFetchResultsController(context: NSManagedObjectContext, queryText: String?) -> NSFetchedResultsController<Suggestion>{
		let request: NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(Suggestion.word), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		if queryText != nil && !queryText!.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(Suggestion.word)) beginswith[c] %@", queryText!)
		}
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	
	class func createSearchSuggestionsFetchResultsController(context: NSManagedObjectContext, queryText: String) -> NSFetchedResultsController<NSDictionary>{
		let request = NSFetchRequest<NSDictionary>(entityName: "Dictionary")
		request.propertiesToFetch = [#keyPath(Dictionary.word)]
		request.resultType = .dictionaryResultType
		request.returnsDistinctResults = true
		request.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(Dictionary.word), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(Dictionary.word)) beginswith[c] %@", queryText)
		}
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	
	class func addSuggestion(word: String) {
		if (Settings.isSearchHistoryEnabled()) {
			AppDelegate.persistentUserDbContainer.performBackgroundTask{ context in
				let request: NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
				request.predicate = NSPredicate(format: "\(#keyPath(Suggestion.word)) =[c] %@", word)
				do {
					if (try context.count(for: request) == 0) {
						let suggestion = Suggestion(context:context)
						suggestion.word = word.lowercased(with: Locale.current)
						try context.save()
					}
				} catch let error {
					print ("Error saving suggestion \(word): \(error)")
				}
			}
		}
	}
	
	class func clearHistory(completion: (() -> Void)?) {
		AppDelegate.persistentUserDbContainer.performBackgroundTask{ context in
			do {
				let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Suggestion")
				let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
				let result = try context.execute(deleteRequest)
				print ("Executed delete request \(result)")
				try context.save()
				if completion != nil {
					DispatchQueue.main.async(execute: completion!)
				}
			} catch let error {
				print ("Error clearing search history \(error)")
			}
		}
	}

}
