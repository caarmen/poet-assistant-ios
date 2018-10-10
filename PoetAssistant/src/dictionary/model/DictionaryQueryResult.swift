//
//  DictionaryQueryResult.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 10/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import Foundation
import CoreData

class DictionaryQueryResult {
	private static let PARTS_OF_SPEECH:[String:PartOfSpeech] = ["n": .noun,
																"a": .adjective,
																"r": .adverb,
																"v": .verb]
	
	let queryText: String
	private let controller: NSFetchedResultsController<Dictionary>
	init(queryText: String, controller: NSFetchedResultsController<Dictionary>) {
		self.queryText = queryText
		self.controller = controller
	}
	func numberOfSections() -> Int {
		return controller.sections?.count ?? 0
	}
	func numberOfRowsInSection(section: Int) -> Int {
		return controller.sections?[section].numberOfObjects ?? 0
	}
	func partOfSpeech(section: Int) -> PartOfSpeech? {
		if let sectionTitle = controller.sections?[section].name {
			return DictionaryQueryResult.PARTS_OF_SPEECH[sectionTitle]
		}
		return nil
	}
	func definition(indexPath: IndexPath) -> String? {
		return controller.object(at: indexPath).definition
	}
}
