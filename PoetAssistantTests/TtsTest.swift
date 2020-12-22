/**
Copyright (c) 2020 Carmen Alvarez

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

import AVFoundation
import XCTest
@testable import PoetAssistant

class TtsTest: XCTestCase {

	func testSplit1() {
		testSplit(input: "To be or not to be", expectedUtterances: [AVSpeechUtterance(string: "To be or not to be")])
	}

	func testSplit2() {
		testSplit(input: "To be or not to be.. that is the question", expectedUtterances: [AVSpeechUtterance(string: "To be or not to be. that is the question")])
	}

	func testSplit3() {
		let expectedUtterance1 = AVSpeechUtterance(string: "To be or not to be")
		let expectedUtterance2 = AVSpeechUtterance(string: " that is the question")
		expectedUtterance2.preUtteranceDelay = 0.5

		testSplit(input: "To be or not to be... that is the question", expectedUtterances: [expectedUtterance1, expectedUtterance2
		])
	}

	func testSplit4() {
		let expectedUtterance1 = AVSpeechUtterance(string: "To be or not to be")
		let expectedUtterance2 = AVSpeechUtterance(string: " that is the question")
		expectedUtterance2.preUtteranceDelay = 1.0

		testSplit(input: "To be or not to be.... that is the question", expectedUtterances: [expectedUtterance1, expectedUtterance2
		])
	}

	func testSplit5() {
		let expectedUtterance1 = AVSpeechUtterance(string: "To be or not to be")
		let expectedUtterance2 = AVSpeechUtterance(string: " that is the question")
		expectedUtterance2.preUtteranceDelay = 1.5

		testSplit(input: "To be or not to be..... that is the question", expectedUtterances: [expectedUtterance1, expectedUtterance2
		])
	}

	func testSplit6() {
		let expectedUtterance1 = AVSpeechUtterance(string: "To be or not to be")
		let expectedUtterance2 = AVSpeechUtterance(string: " that is the question")
		expectedUtterance2.preUtteranceDelay = 2.0

		testSplit(input: "To be or not to be...... that is the question", expectedUtterances: [expectedUtterance1, expectedUtterance2
		])
	}

	func testSplit7() {
		let expectedUtterance1 = AVSpeechUtterance(string: "To be  ")
		let expectedUtterance2 = AVSpeechUtterance(string: " or not to be")
		expectedUtterance2.preUtteranceDelay = 0.5
		let expectedUtterance3 = AVSpeechUtterance(string: " that is the question")
		expectedUtterance3.preUtteranceDelay = 0.5

		testSplit(input: "To be  ... or not to be... that is the question", expectedUtterances: [expectedUtterance1, expectedUtterance2, expectedUtterance3
		])
	}

	func testSplit8() {
		testSplit(input: "To be or not to be. That is the question", expectedUtterances: [AVSpeechUtterance(string: "To be or not to be. That is the question")])
	}

	func testSplit9() {
		testSplit(input: "To be or not to be. That. is. the. question", expectedUtterances: [AVSpeechUtterance(string: "To be or not to be. That. is. the. question")])
	}

	func testSplit10() {
		testSplit(input: "To be or not to be.. That.. is.. the.. question", expectedUtterances: [AVSpeechUtterance(string: "To be or not to be. That. is. the. question")])
	}

	func testSplit11() {
		testSplit(input: "To be or not to be.\nThat..\nis.\n the\nquestion", expectedUtterances: [AVSpeechUtterance(string: "To be or not to be.\nThat.\nis.\n the\nquestion")])
	}

	func testSplitDotsOnly1() {
		testSplit(input: ".", expectedUtterances:[])
	}

	func testSplitDotsOnly2() {
		testSplit(input: "..", expectedUtterances:[])
	}

	func testSplitDotsOnly3() {
		testSplit(input: "...", expectedUtterances:[])
	}

	func testSplitDotsOnly4() {
		testSplit(input: "....", expectedUtterances:[])
	}

	func testEmpty() {
		testSplit(input: "", expectedUtterances: [])
	}

	private func testSplit(input: String, expectedUtterances: [AVSpeechUtterance]) {
		let actualUtterances = Tts.createUtterances(text: input)
		XCTAssertEqual(expectedUtterances.count, actualUtterances.count)
		if (expectedUtterances.count == actualUtterances.count) {
			for i in 0..<expectedUtterances.count {
				XCTAssertEqual(expectedUtterances[i].speechString, actualUtterances[i].speechString)
				XCTAssertEqual(expectedUtterances[i].preUtteranceDelay, actualUtterances[i].preUtteranceDelay)
			}
		}
	}
}
