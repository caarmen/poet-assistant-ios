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

import Foundation
import CoreData

enum SuggestionType {
	case history
	case dictionary
}
class SuggestionRowItem {
	let type: SuggestionType
	let word: String
	init(type: SuggestionType, word: String) {
		self.type = type
		self.word = word
	}
}
class SuggestionsFetchedResultsControllerWrapper {
	private var historyFetchedResultsController: NSFetchedResultsController<Suggestion>?
	private var dictionaryFetchedResultsController: NSFetchedResultsController<NSDictionary>?
	private static let SECTION_HISTORY = "suggestions_section_history"
	private static let SECTION_DICTIONARY = "suggestions_section_dictionary"
	private let queryText: String?
	
	init(queryText: String?) {
		self.queryText = queryText
	}
	var sections = [NSFetchedResultsSectionInfo]()
	
	func object(at: IndexPath) -> SuggestionRowItem? {
		let indexPathForRealController = IndexPath(row: at.row, section: 0)
		let sectionName = sections[at.section].name
		if sectionName == SuggestionsFetchedResultsControllerWrapper.SECTION_HISTORY {
			let historySuggestion = historyFetchedResultsController?.object(at: indexPathForRealController)
			return SuggestionRowItem(type: .history, word: historySuggestion?.word ?? "")
		} else {
			let dictionarySuggestion = dictionaryFetchedResultsController?.object(at: indexPathForRealController)
			return SuggestionRowItem(type: .dictionary, word: dictionarySuggestion?[#keyPath(Dictionary.word)] as? String ?? "")
		}
	}
	
	func performFetch() throws {
		
		let historyContext = AppDelegate.persistentUserDbContainer.newBackgroundContext()
		let dictionaryContext = AppDelegate.persistentDictionariesContainer.newBackgroundContext()
		historyFetchedResultsController = Suggestion.createHistorySearchSuggestionsFetchResultsController(context: historyContext, queryText: queryText)
		dictionaryFetchedResultsController = (queryText == nil || queryText!.isEmpty) ? nil :  Dictionary.createSearchSuggestionsFetchResultsController(context: dictionaryContext, queryText: queryText!)
		do {
			try historyFetchedResultsController?.performFetch()
			try dictionaryFetchedResultsController?.performFetch()
			if let historySearchSections = historyFetchedResultsController?.sections, historySearchSections.count == 1, historySearchSections[0].numberOfObjects > 0 {
				sections.append(SectionInfo(
					name: SuggestionsFetchedResultsControllerWrapper.SECTION_HISTORY,
					numberOfObjects: historySearchSections[0].numberOfObjects,
					objects: historySearchSections[0].objects))
			}
			if let dictionarySearchSections = dictionaryFetchedResultsController?.sections, dictionarySearchSections.count == 1 {
				sections.append(SectionInfo(
					name: SuggestionsFetchedResultsControllerWrapper.SECTION_DICTIONARY,
					numberOfObjects: dictionarySearchSections[0].numberOfObjects,
					objects: dictionarySearchSections[0].objects))
			}
		} catch let error {
			throw error
		}
	}
}
