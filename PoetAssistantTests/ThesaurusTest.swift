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

import XCTest
@testable import PoetAssistantLexiconsFramework

class ThesaurusTest: XCTestCase {
	
	
	func testThesaurusLookup() {
		guard let thesaurusQueryResult = Thesaurus.fetch(context: CoreDataAccess.persistentDictionariesContainer.viewContext, queryText: "mistake", favorites: []) else {
			XCTFail("no thesaurus result")
			return
		}
		
		XCTAssertEqual(2, thesaurusQueryResult.sections.count)
		assertExpectedForwardThesaurusEntryForMistake(thesaurusQueryResult: thesaurusQueryResult)
		
		
	}
	
	func testReverseThesaurusLookup() {
		guard let thesaurusQueryResult = Thesaurus.fetch(context: CoreDataAccess.persistentDictionariesContainer.viewContext, queryText: "mistake", favorites: [], includeReverseLookup: true) else {
			XCTFail("no thesaurus result")
			return
		}
		XCTAssertEqual(4, thesaurusQueryResult.sections.count)
		assertExpectedForwardThesaurusEntryForMistake(thesaurusQueryResult: thesaurusQueryResult)
		var partOfSpeechIndex = 2
		assertThesaurusListSection(expectedPartOfSpeech: .noun,
								   expectedEntries:[
									ThesaurusListItem.subtitle(.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "balls-up", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "ballup", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "betise", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "bloomer", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "blooper", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "blot", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "blunder", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "boner", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "boo-boo", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "botch", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "bungle", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "cockup", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "confusion", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "corrigendum", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "distortion", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "erratum", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "flub", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "folly", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "foolishness", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "foul-up", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "fuckup", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "imbecility", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "incursion", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "lapse", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "literal", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "literal error", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "mess-up", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "miscalculation", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "miscue", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misestimation", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misprint", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misreckoning", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "mix-up", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "offside", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "omission", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "oversight", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "parapraxis", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "pratfall", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "renege", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "revoke", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "skip", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "slip-up", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "smear", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "smirch", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "spot", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "stain", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "stupidity", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "typo", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "typographical error", isFavorite: false)),
									],
								   actualThesaurusListSection: thesaurusQueryResult.sections[partOfSpeechIndex])
		partOfSpeechIndex += 1
		assertThesaurusListSection(expectedPartOfSpeech: .verb,
								   expectedEntries:[
									ThesaurusListItem.subtitle(.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "confound", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "confuse", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "fall for", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misjudge", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misremember", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "stumble", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "trip up", isFavorite: false))],
								   actualThesaurusListSection: thesaurusQueryResult.sections[partOfSpeechIndex])
	}
	
	private func assertExpectedForwardThesaurusEntryForMistake(thesaurusQueryResult: ThesaurusQueryResult) {
		var partOfSpeechIndex: Int = 0
		assertThesaurusListSection(expectedPartOfSpeech: .noun,
								   expectedEntries: [
									ThesaurusListItem.subtitle(WordRelationship.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "nonaccomplishment", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "nonachievement", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "error", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "fault", isFavorite: false)),
									ThesaurusListItem.subtitle(WordRelationship.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misunderstanding", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misapprehension", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misconception", isFavorite: false)),
									ThesaurusListItem.subtitle(WordRelationship.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misstatement", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "error", isFavorite: false))],
								   actualThesaurusListSection: thesaurusQueryResult.sections[partOfSpeechIndex])
		
		partOfSpeechIndex += 1
		assertThesaurusListSection(expectedPartOfSpeech: .verb,
								   expectedEntries: [
									ThesaurusListItem.subtitle(WordRelationship.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "misidentify", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "identify", isFavorite: false)),
									ThesaurusListItem.subtitle(WordRelationship.synonym),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "slip up", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "err", isFavorite: false)),
									ThesaurusListItem.wordEntry(ThesaurusWordEntry(word: "slip", isFavorite: false))],
								   actualThesaurusListSection: thesaurusQueryResult.sections[partOfSpeechIndex])
		
	}
	private func assertThesaurusListSection(expectedPartOfSpeech: PartOfSpeech, expectedEntries: [ThesaurusListItem], actualThesaurusListSection: ThesaurusListSection) {
		XCTAssertEqual(expectedPartOfSpeech, actualThesaurusListSection.partOfSpeech)
		XCTAssertEqual(expectedEntries.count, actualThesaurusListSection.entries.count)
		for i in 0..<expectedEntries.count {
			let expectedItem = expectedEntries[i]
			let actualItem = actualThesaurusListSection.entries[i]
			XCTAssertEqual(expectedItem, actualItem)
		}
	}
	
}
