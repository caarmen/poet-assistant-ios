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
	func toText() -> String {
		var result = String(format: NSLocalizedString("share_dictionary_title", comment: ""), queryText)
		for section in 0..<numberOfSections() {
			if let partOfSpeech = partOfSpeech(section:section) {
				for row in 0..<numberOfRowsInSection(section: section) {
					if let definition = definition(indexPath: IndexPath(row:row, section:section)) {
						result.append(String(format: NSLocalizedString("share_dictionary_definition", comment: ""), partOfSpeech.localizedAbbreviation(), definition))
					}
				}
			}
		}
		return result
	}
}
