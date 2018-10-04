//
//  Dictionary.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData

class Dictionary: NSManagedObject {
	static let COLUMN_WORD = "word"
	
	class func createQueryFetchResultsController(context: NSManagedObjectContext, queryText: String) -> NSFetchedResultsController<NSDictionary>{
		let request = NSFetchRequest<NSDictionary>(entityName: "Dictionary")
		request.propertiesToFetch = [COLUMN_WORD]
		request.resultType = .dictionaryResultType
		request.returnsDistinctResults = true
		request.sortDescriptors = [NSSortDescriptor(key: COLUMN_WORD, ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(COLUMN_WORD) beginswith[c] %@", queryText)
		}
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	class func createFetchResultsController(context: NSManagedObjectContext, queryText: String) -> NSFetchedResultsController<Dictionary> {
		let request: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: COLUMN_WORD, ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(COLUMN_WORD) ==[c] %@", queryText)
		}
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
}
