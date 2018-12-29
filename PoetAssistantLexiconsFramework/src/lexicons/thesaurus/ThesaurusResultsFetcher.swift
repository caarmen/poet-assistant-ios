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
	
	func fetch(context: NSManagedObjectContext, queryText: String, favorites: [String], includeReverseLookup: Bool = false) throws -> ThesaurusQueryResult {
		
		do {
			var usedQueryText = queryText
			var sections = try fetchImpl(context: context, queryText: queryText, favorites: favorites, includeReverseLookup: includeReverseLookup)
			if sections.count == 0 {
				if let closestWord = Stems.findClosestWord(word: queryText, context: context), closestWord != queryText {
					sections = try fetchImpl(context:context, queryText: closestWord, favorites: favorites, includeReverseLookup: includeReverseLookup)
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
	private func fetchImpl(context: NSManagedObjectContext, queryText: String, favorites: [String], includeReverseLookup: Bool = false) throws -> [ThesaurusListSection]  {
		if queryText.isEmpty {
			return []
		}
		do {
			var resultSections = [ThesaurusListSection]()
			let fetchedResultsController = createForwardSearchResultsController(context: context, queryText: queryText)
			try fetchedResultsController.performFetch()
			
			// The sections are grouped by part of speech. For example, we'll have a section
			// for the "adjective" meanings of this word (there may be a few adjective meanings for
			// the given word). Then we'll have a section of the "noun" meanings of the word, etc.
			// We'll put this into a different format:
			// We'll keep the parts-of-speech sections, but in each section, we'll one synonym or
			// antonym per entry. We'll have "subsections" too, which are just a different type of entry.
			// They indicate if the words that follow are synonyms or antonyms.
			if (fetchedResultsController.sections != nil) {
				var forwardSynonyms: [String] = []
				var forwardAntonyms: [String] = []
				for (originalSectionIndex, originalSection) in fetchedResultsController.sections!.enumerated() {
					var thesaurusListItems = [ThesaurusListItem]()
					
					for originalRowIndex in 0..<originalSection.numberOfObjects {
						
						let originalEntry = fetchedResultsController.object(at: IndexPath(row: originalRowIndex, section:originalSectionIndex))
						if originalEntry.synonyms != nil && !originalEntry.synonyms!.isEmpty {
							let synonyms = originalEntry.synonyms!.components(separatedBy: ",")
							forwardSynonyms.append(contentsOf: synonyms)
							thesaurusListItems.append(contentsOf: createThesaurusListItems(wordRelationship: .synonym, listOfWords: synonyms, favorites: favorites))
						}
						if originalEntry.antonyms != nil && !originalEntry.antonyms!.isEmpty {
							let antonyms = originalEntry.antonyms!.components(separatedBy: ",")
							forwardAntonyms.append(contentsOf: antonyms)
							thesaurusListItems.append(contentsOf: createThesaurusListItems(wordRelationship: .antonym, listOfWords: antonyms, favorites: favorites))
						}
					}
					let partOfSpeech = ThesaurusResultsFetcher.PARTS_OF_SPEECH[originalSection.name] ?? .noun
					let newSection = ThesaurusListSection(partOfSpeech:partOfSpeech, entries:thesaurusListItems)
					resultSections.append(newSection)
					
				}
				if (includeReverseLookup) {
					let relatedSynonyms = try fetchReverseRelatedWords(context: context,
																	   relationshipColumn: #keyPath(Thesaurus.synonyms),
																	   word: queryText,
																	   excludeRelatedWords: forwardSynonyms)
					
					let relatedAntonyms = try fetchReverseRelatedWords(context: context,
																	   relationshipColumn: #keyPath(Thesaurus.antonyms),
																	   word: queryText,
																	   excludeRelatedWords: forwardAntonyms)
					let relatedSections = createThesaurusListSections(synonymEntries: relatedSynonyms, antonymEntries: relatedAntonyms, favorites: favorites)
					resultSections.append(contentsOf: relatedSections)
				}
			}
			return resultSections
		} catch let error {
			throw error
		}
	}
	
	// return words which have the given word as a synonym or antonym (depending on the relationshipColumn). The result groups words by part of speech.
	private func fetchReverseRelatedWords(context: NSManagedObjectContext, relationshipColumn: String, word: String, excludeRelatedWords: [String]) throws -> [PartOfSpeech:[String]] {
		let fetchedResultsController = createReverseSearchResultsController(context: context, relationshipColumn: relationshipColumn, queryText: word)
		try fetchedResultsController.performFetch()
		var reverseRelatedWords = [PartOfSpeech:[String]]()
		
		fetchedResultsController.sections?.forEach { section in
			section.objects?.filter { !excludeRelatedWords.contains(($0 as! Thesaurus).word!)}.forEach {object in
				let entry = object as! Thesaurus
				let partOfSpeech = ThesaurusResultsFetcher.PARTS_OF_SPEECH[entry.word_type!] ?? .noun
				var wordEntries = reverseRelatedWords[partOfSpeech] ?? []
				wordEntries.append(entry.word!)
				reverseRelatedWords[partOfSpeech] = wordEntries
			}
		}
		return reverseRelatedWords
	}
	
	// return a controller which matches entries having the given queryText as the "word" attribute
	private func createForwardSearchResultsController(context: NSManagedObjectContext, queryText: String) -> NSFetchedResultsController<Thesaurus> {
		let request: NSFetchRequest<Thesaurus> = Thesaurus.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(Thesaurus.word_type))", ascending: true)]
		request.predicate = NSPredicate(format: "\(#keyPath(Thesaurus.word)) ==[c] %@", queryText)
		return NSFetchedResultsController<Thesaurus>(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: #keyPath(Thesaurus.word_type),
			cacheName: nil)
	}
	
	// return a controller which matches entries whose synonyms or antonyms (determined by the relationshipColumn) contain the given queryText
	private func createReverseSearchResultsController(context: NSManagedObjectContext, relationshipColumn: String, queryText: String) -> NSFetchedResultsController<Thesaurus> {
		let request: NSFetchRequest<Thesaurus> = Thesaurus.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(Thesaurus.word_type))", ascending: true)]
		request.predicate = NSPredicate(format: "\(relationshipColumn) beginsWith[c] %@ OR \(relationshipColumn) endsWith[c] %@ OR \(relationshipColumn) contains[c] %@",
			"\(queryText),", // first related word
			",\(queryText)", // last related word
			",\(queryText)," // somewhere in the list of related words
		)
		return NSFetchedResultsController<Thesaurus>(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	
	// return one section per part of speech. Each section may contain ThesaurusListItems for synonyms or antonyms or both.
	private func createThesaurusListSections(synonymEntries: [PartOfSpeech: [String]], antonymEntries: [PartOfSpeech: [String]], favorites: [String]) -> [ThesaurusListSection] {
		var sections: [ThesaurusListSection] = []
		PartOfSpeech.allCases.forEach { partOfSpeech in
			var entriesForPartOfSpeech: [ThesaurusListItem] = []
			if let synonymsForPartOfSpeech = synonymEntries[partOfSpeech] {
				entriesForPartOfSpeech.append(contentsOf: createThesaurusListItems(wordRelationship: .synonym, listOfWords: synonymsForPartOfSpeech, favorites: favorites))
			}
			if let antonymsForPartOfSpeech = antonymEntries[partOfSpeech] {
				entriesForPartOfSpeech.append(contentsOf: createThesaurusListItems(wordRelationship: .antonym, listOfWords: antonymsForPartOfSpeech, favorites: favorites))
			}
			if !entriesForPartOfSpeech.isEmpty {
				sections.append(ThesaurusListSection(partOfSpeech: partOfSpeech, entries: entriesForPartOfSpeech))
			}
		}
		return sections
	}

	private func createThesaurusListItems(wordRelationship: WordRelationship, listOfWords: [String], favorites: [String]) -> [ThesaurusListItem] {
		if (listOfWords.isEmpty) {
			return []
		}
		var result = [ThesaurusListItem]()
		result.append(ThesaurusListItem.subtitle(wordRelationship))
		result.append(contentsOf:
			listOfWords.map { word in
				ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: word, isFavorite: favorites.contains(word))) })
		return result
	}
}
