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


class SuggestionsFetchedResultsControllerWrapper {
	private let historyFetchedResultsController: NSFetchedResultsController<Suggestion>
	private let dictionaryFetchedResultsController: NSFetchedResultsController<NSDictionary>?
	private static let SECTION_HISTORY = "suggestions_section_history"
	private static let SECTION_DICTIONARY = "suggestions_section_dictionary"
	
	init(historyFetchedResultsController: NSFetchedResultsController<Suggestion>,
		 dictionaryFetchedResultsController: NSFetchedResultsController<NSDictionary>?) {
		self.historyFetchedResultsController = historyFetchedResultsController
		self.dictionaryFetchedResultsController = dictionaryFetchedResultsController
	}
	var sections = [NSFetchedResultsSectionInfo]()
	
	func object(at: IndexPath) -> String? {
		let indexPathForRealController = IndexPath(row: at.row, section: 0)
		let sectionName = sections[at.section].name
		if sectionName == SuggestionsFetchedResultsControllerWrapper.SECTION_HISTORY {
			let historySuggestion = historyFetchedResultsController.object(at: indexPathForRealController)
			return historySuggestion.word
		} else {
			let dictionarySuggestion = dictionaryFetchedResultsController?.object(at: indexPathForRealController)
			return dictionarySuggestion?[#keyPath(Dictionary.word)] as? String
		}
	}
	
	func performFetch() throws {
		do {
			try historyFetchedResultsController.performFetch()
			try dictionaryFetchedResultsController?.performFetch()
			if let historySearchSections = historyFetchedResultsController.sections, historySearchSections.count == 1 {
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
