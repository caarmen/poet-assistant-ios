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

enum WordRelationship {
	case synonym
	case antonym
}
enum ThesaurusListItem {
	case subtitle(WordRelationship)
	case wordEntry(ThesaurusWordEntry)
}
struct ThesaurusWordEntry {
	let word: String
	let isFavorite: Bool
}
class ThesaurusListSection {
	let partOfSpeech: PartOfSpeech
	let entries: [ThesaurusListItem]
	init(partOfSpeech: PartOfSpeech, entries: [ThesaurusListItem]) {
		self.partOfSpeech = partOfSpeech
		self.entries = entries
	}
}
class ThesaurusQueryResult {
	let queryText: String
	let sections:  [ThesaurusListSection]
	
	init(queryText: String, sections: [ThesaurusListSection]) {
		self.queryText = queryText
		self.sections = sections
	}
	
	func object(at: IndexPath) -> ThesaurusListItem? {
		let section = sections[at.section]
		return section.entries[at.row]
	}
	func toText() -> String {
		var result = String(format: NSLocalizedString("share_thesaurus_title", comment: ""), queryText)
		sections.forEach { section in
			result.append("\n\(section.partOfSpeech.toLocalizedString())\n")
			section.entries.forEach { entry in
				switch(entry) {
				case .subtitle(let wordRelationship):
					let subtitleStringId = wordRelationship == .synonym ? "share_thesaurus_subtitle_synonym" : "share_thesaurus_subtitle_antonym"
					result.append(NSLocalizedString(subtitleStringId, comment: ""))
				case .wordEntry(let thesaurusWordEntry):
					result.append(String(format: NSLocalizedString("share_thesaurus_word", comment: ""), thesaurusWordEntry.word))
				}
			}
		}
		return result
	}
}
