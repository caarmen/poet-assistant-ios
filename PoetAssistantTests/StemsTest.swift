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

@testable import PoetAssistant
class StemsTest: XCTestCase {
	
	func testFindClosestWord() {
		assertClosestWord(word: "happy", similarWords:["happiness", "sadness"], expectedClosestWord: "happiness")
		assertClosestWord(word: "happiness", similarWords:["happy", "sadness"], expectedClosestWord: "happy")

		assertClosestWord(word: "animations", similarWords:["animated", "animation"], expectedClosestWord: "animation")
		assertClosestWord(word: "animations", similarWords:["animation", "animated"], expectedClosestWord: "animation")

		assertClosestWord(word: "happy", similarWords:["completely", "unrelated"], expectedClosestWord: nil)
		assertClosestWord(word: "happy", similarWords:[], expectedClosestWord: nil)
		assertClosestWord(word: "happy", similarWords:["",""], expectedClosestWord: nil)
	}
	
	private func assertClosestWord(word: String, similarWords: [String], expectedClosestWord: String?) {
		let actualClosestWord = Stems.findClosestWord(word: word, similarWords: similarWords)
		XCTAssertEqual(expectedClosestWord, actualClosestWord, "Expected closest word for \(word) to be \(expectedClosestWord ?? "nil") but found actual closest word \(actualClosestWord ?? "nil")")
	}
	
	func testWordSimilarities() {
		assertSimilarityScore(word1: "animations", word2: "animation", expectedScore: 9)
		assertSimilarityScore(word1: "happy", word2: "sad", expectedScore: 0)
		assertSimilarityScore(word1: "happy", word2: "hungry", expectedScore: 1)
		assertSimilarityScore(word1: "happy", word2: "", expectedScore: 0)
		assertSimilarityScore(word1: "", word2: "", expectedScore: 0)
		assertSimilarityScore(word1: "equal", word2: "equal", expectedScore: 5)
		
	}
	
	private func assertSimilarityScore(word1: String, word2: String, expectedScore: Int) {
		let actualScore = Stems.calculateSimilarityScore(word1: word1, word2: word2)
		XCTAssertEqual(expectedScore, actualScore, "Expected score \(expectedScore) for \(word1) and \(word2) but got actual score \(actualScore)");
		
		// make sure the reverse works too
		let actualScoreReversed = Stems.calculateSimilarityScore(word1: word2, word2: word1)
		XCTAssertEqual(expectedScore, actualScoreReversed, "Expected score \(expectedScore) for \(word2) and \(word1) but got actual score \(actualScore)");
	}
	
}
