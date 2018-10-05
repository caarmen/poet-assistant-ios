//
//  Thesaurus.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData

class Thesaurus: NSManagedObject {
	class func createFetchResultsController(context: NSManagedObjectContext, queryText: String) -> ThesaurusFetchedResultsControllerWrapper {
		let request: NSFetchRequest<Thesaurus> = Thesaurus.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(Thesaurus.word_type))", ascending: true)]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(Thesaurus.word)) ==[c] %@", queryText)
		}
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(Thesaurus.word)) beginswith[c] %@", queryText)
		}
		let fetchedResultsController = NSFetchedResultsController<Thesaurus>(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: #keyPath(Thesaurus.word_type),
			cacheName: nil)
		return ThesaurusFetchedResultsControllerWrapper(fetchedResultsController: fetchedResultsController)
	}
}
