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

class ThesaurusResultsFetcher {
	
	private static let PARTS_OF_SPEECH:[String:PartOfSpeech] = ["NOUN": .noun,
														   "ADJ": .adjective,
														   "ADV": .adverb,
														   "VERB": .verb]
	
	func fetch(context: NSManagedObjectContext, queryText: String) throws -> ThesaurusQueryResult {
		
		do {
			var usedQueryText = queryText
			var sections = try fetchImpl(context: context, queryText: queryText)
			if sections.count == 0 {
				if let closestWord = Stems.findClosestWord(word: queryText, context: context), closestWord != queryText {
					sections = try fetchImpl(context:context, queryText: closestWord)
					if (sections.count != 0) {
						usedQueryText = closestWord
					}
				}
			}
			return ThesaurusQueryResult(queryText: usedQueryText, sections: sections)
		} catch let error {
			throw error
		}
	}
	
	//
	// The thesaurus db is in a strange format:
	// A given word has two columns: one for synonyms and one for antonyms. The value
	// in each of these columns is a comma-separated list of the related words.
	// We need to extract this into a structure with one entry per related word.
	//
	// Note that in the original data source, a given word may have multiple rows: each
	// row corresponds to a different "meaning" of the word.
	//
	private func fetchImpl(context: NSManagedObjectContext, queryText: String) throws -> [ThesaurusListSection]  {
		do {
			var resultSections = [ThesaurusListSection]()
			let fetchedResultsController = createNSFetchedResultsController(context: context, queryText: queryText)
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
					var thesaurusListItems = [ThesaurusListItem]()
					
					let numberOfObjects = originalSection.numberOfObjects
					for originalRowIndex in 0..<numberOfObjects {
						let originalEntry = fetchedResultsController.object(at: IndexPath(row: originalRowIndex, section:originalSectionIndex))
						if let synonyms = originalEntry.synonyms {
							thesaurusListItems.append(contentsOf: createThesaurusListItems(wordRelationship: .synonym, listOfWords: synonyms))
						}
						if let antonyms = originalEntry.antonyms {
							thesaurusListItems.append(contentsOf: createThesaurusListItems(wordRelationship: .antonym, listOfWords: antonyms))
						}
					}
					let partOfSpeech = ThesaurusResultsFetcher.PARTS_OF_SPEECH[originalSection.name] ?? .noun
					let newSection = ThesaurusListSection(partOfSpeech:partOfSpeech, entries:thesaurusListItems)
					resultSections.append(newSection)
				}
			}
			return resultSections
		} catch let error {
			throw error
		}
	}
	
	private func createNSFetchedResultsController(context: NSManagedObjectContext, queryText: String) -> NSFetchedResultsController<Thesaurus> {
		let request: NSFetchRequest<Thesaurus> = Thesaurus.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(Thesaurus.word_type))", ascending: true)]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(Thesaurus.word)) ==[c] %@", queryText)
		}
		return NSFetchedResultsController<Thesaurus>(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: #keyPath(Thesaurus.word_type),
			cacheName: nil)
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
