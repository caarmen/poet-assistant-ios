//
//  Thesaurus.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData

class Thesaurus: NSManagedObject {
	static let COLUMN_WORD = "word"
	static let COLUMN_WORD_TYPE = "word_type"
	static let COLUMN_SYNONYMS = "synonyms"
	static let COLUMN_ANTONYMS = "antonyms"
	

	class func createFetchResultsController(context: NSManagedObjectContext, queryText: String) -> ThesaurusFetchedResultsController {
		let request: NSFetchRequest<Thesaurus> = Thesaurus.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: COLUMN_WORD_TYPE, ascending: true)]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(COLUMN_WORD) ==[c] %@", queryText)
		}
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(COLUMN_WORD) beginswith[c] %@", queryText)
		}
		let fetchedResultsController = NSFetchedResultsController<Thesaurus>(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: COLUMN_WORD_TYPE,
			cacheName: nil)
		return ThesaurusFetchedResultsController(fetchedResultsController: fetchedResultsController)
	}
}
