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

class ThesaurusFetchedResultsControllerWrapper {
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
	
	//
	// The thesaurus db is in a strange format:
	// A given word has two columns: one for synonyms and one for antonyms. The value
	// in each of these columns is a comma-separated list of the related words.
	// We need to extract this into a structure with one entry per related word.
	//
	// Note that in the original data source, a given word may have multiple rows: each
	// row corresponds to a different "meaning" of the word.
	//
	func performFetch() throws {
		do {
			try fetchedResultsController.performFetch()
			
			// The sections are grouped by part of speech. For example, we'll have a section
			// for the "adjective" meanings of this word (there may be a few adjective meanings for
			// the given word). Then we'll have a section of the "noun" meanings of the word, etc.
			// We'll put this into a different format:
			// We'll keep the parts-of-speech sections, but in each section, we'll one synonym or
			// antonym per entry. We'll have "subsections" too, which are just a different type of entry.
			// They indicate if the words that follow are synonyms or antonyms.
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
