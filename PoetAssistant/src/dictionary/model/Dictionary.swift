//
//  Dictionary.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

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
