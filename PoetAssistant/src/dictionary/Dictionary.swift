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
	
	class func createFetchResultsController(context: NSManagedObjectContext, queryText: String, sortColumn: String, ascendingSort: Bool) -> NSFetchedResultsController<Dictionary> {
		let request: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: sortColumn, ascending: ascendingSort, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(COLUMN_WORD) contains[c] %@", queryText)
		}
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
}
