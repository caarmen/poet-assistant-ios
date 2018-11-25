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

public enum WordRelationship {
	case synonym
	case antonym
}
public enum ThesaurusListItem {
	case subtitle(WordRelationship)
	case wordEntry(ThesaurusWordEntry)
}
public struct ThesaurusWordEntry {
	public let word: String
	public let isFavorite: Bool
}
public class ThesaurusListSection {
	public let partOfSpeech: PartOfSpeech
	public let entries: [ThesaurusListItem]
	init(partOfSpeech: PartOfSpeech, entries: [ThesaurusListItem]) {
		self.partOfSpeech = partOfSpeech
		self.entries = entries
	}
}
public class ThesaurusQueryResult {
	public let queryText: String
	public let sections:  [ThesaurusListSection]
	
	public init(queryText: String, sections: [ThesaurusListSection]) {
		self.queryText = queryText
		self.sections = sections
	}
	
	public func object(at: IndexPath) -> ThesaurusListItem? {
		let section = sections[at.section]
		return section.entries[at.row]
	}
	public func toText() -> String {
		var result = String(format: NSLocalizedString("share_thesaurus_title", comment: ""), queryText)
		sections.forEach { section in
			result.append("\n\(section.partOfSpeech.localizedSectionLabel())\n")
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
