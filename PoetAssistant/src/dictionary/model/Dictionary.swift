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

class Dictionary: NSManagedObject {
	static let PART_OF_SPEECH_NOUN = "n"
	static let PART_OF_SPEECH_VERB = "v"
	static let PART_OF_SPEECH_ADJECTIVE = "a"
	static let PART_OF_SPEECH_ADVERB = "r"
	
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
	
	class func createDefinitionsFetchResultsController(context: NSManagedObjectContext, queryText: String) -> NSFetchedResultsController<Dictionary> {
		let request: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(Dictionary.part_of_speech), ascending: true),
			NSSortDescriptor(key: #keyPath(Dictionary.word), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(Dictionary.word)) ==[c] %@", queryText)
		}
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: #keyPath(Dictionary.part_of_speech),
			cacheName: nil)
	}
}
