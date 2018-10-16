//
//  ThesaurusQueryResult.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 09/10/2018.
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
}
