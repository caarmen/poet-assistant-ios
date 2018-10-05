//
//  ThesaurusFetchedResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData

enum WordRelationship {
	case synonym
	case antonym
}
enum ThesaurusListItem {
	case subtitle(WordRelationship)
	case word(String)
}

class ThesaurusFetchedResultsController {
	private let fetchedResultsController : NSFetchedResultsController<Thesaurus>
	
	var sections = [NSFetchedResultsSectionInfo]()
	
	init(fetchedResultsController: NSFetchedResultsController<Thesaurus>) {
		self.fetchedResultsController = fetchedResultsController
	}
	
	func object(at: IndexPath) -> ThesaurusListItem? {
		let section = sections[at.section]
		return section.objects?[at.row] as? ThesaurusListItem
	}
	
	private var wordTypeLabels:[String:String] = ["NOUN": "part_of_speech_n",
								  "ADJ": "part_of_speech_a",
								  "ADV": "part_of_speech_r",
								  "VERB": "part_of_speech_v"]
	func performFetch() throws {
		do {
			try fetchedResultsController.performFetch()
			if (fetchedResultsController.sections != nil) {
				for (originalSectionIndex, originalSection) in fetchedResultsController.sections!.enumerated() {
					var objectsInSection = [ThesaurusListItem]()
					
					let numberOfObjects = originalSection.numberOfObjects
					for originalRowIndex in 0..<numberOfObjects {
						let originalEntry = fetchedResultsController.object(at: IndexPath(row: originalRowIndex, section:originalSectionIndex))
						if let synonyms = originalEntry.synonyms {
							objectsInSection.append(contentsOf: createThesaurusListItems(wordRelationship: .synonym, listOfWords: synonyms))
						}
						if let antonyms = originalEntry.antonyms {
							objectsInSection.append(contentsOf: createThesaurusListItems(wordRelationship: .antonym, listOfWords: antonyms))
						}
					}
					let newSection = SectionInfo(
						name: wordTypeLabels[originalSection.name] ?? "",
						numberOfObjects: objectsInSection.count,
						objects: objectsInSection)
					sections.append(newSection)
				}
			}
		} catch let error {
			throw error
		}
	}
	
	private func createThesaurusListItems(wordRelationship: WordRelationship, listOfWords: String) -> [ThesaurusListItem] {
		if (listOfWords.isEmpty) {
			return []
		}
		var result = [ThesaurusListItem]()
		result.append(ThesaurusListItem.subtitle(wordRelationship))
		result.append(contentsOf:
			listOfWords.components(separatedBy: ",").map { word in ThesaurusListItem.word(word) })
		return result
	}
}
