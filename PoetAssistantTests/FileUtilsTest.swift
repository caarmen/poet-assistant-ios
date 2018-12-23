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
class FileUtilsTest: XCTestCase {
	
	func testGetUsableFilename() {
		testGetUsableFilename(expectedFilename:"YoLo.txt", actualUserInput:"YoLo.txt")
		testGetUsableFilename(expectedFilename:"hello.txt", actualUserInput:"hello")
		testGetUsableFilename(expectedFilename:"poem.txt", actualUserInput:"👨🏽‍✈️")
		testGetUsableFilename(expectedFilename:"some files with spaces.txt", actualUserInput:"some files with spaces")
		testGetUsableFilename(expectedFilename:"slash.txt", actualUserInput:"slash/")
	}
	
	private func testGetUsableFilename(expectedFilename: String, actualUserInput: String) {
		XCTAssertEqual(expectedFilename, FileUtils.getUsableFilename(userEnteredFilename: actualUserInput))
	}
	
	func testGetSuggestedNewFilename() {
		XCTAssertEqual("poem.txt", FileUtils.getSuggestedNewFilename(poemText: ""))
		XCTAssertEqual("poem.txt", FileUtils.getSuggestedNewFilename(poemText: "& 2 !,$*-)°"))
		XCTAssertEqual("Unthrifty.txt", FileUtils.getSuggestedNewFilename(poemText: "Unthrifty loveliness, why dost thou spend"))
		XCTAssertEqual("Against-my-love.txt", FileUtils.getSuggestedNewFilename(poemText: "Against my love shall be as I am now,"))
		XCTAssertEqual("As-a-decrepit.txt", FileUtils.getSuggestedNewFilename(poemText: "As a decrepit father takes delight"))
		XCTAssertEqual("Canst-thou-O.txt", FileUtils.getSuggestedNewFilename(poemText: "Canst thou, O cruel! say I love thee not,"))
		XCTAssertEqual("Farewell-thou.txt", FileUtils.getSuggestedNewFilename(poemText: "Farewell! thou art too dear for my possessing,"))
		XCTAssertEqual("Lo-in-the.txt", FileUtils.getSuggestedNewFilename(poemText: "Lo! in the orient when the gracious light"))
		XCTAssertEqual("Roses-are-red.txt", FileUtils.getSuggestedNewFilename(poemText: "Roses are red,\nviolets are blue"))
		XCTAssertEqual("Róses-àré-réd.txt", FileUtils.getSuggestedNewFilename(poemText: "Róses àré réd,\nvïólèts áré blüë"))
		XCTAssertEqual("Short.txt", FileUtils.getSuggestedNewFilename(poemText: "Short"))
		XCTAssertEqual("abcdefgh.txt", FileUtils.getSuggestedNewFilename(poemText: "abcdefgh"))
		XCTAssertEqual("abcdefghi.txt", FileUtils.getSuggestedNewFilename(poemText: "abcdefghi"))
		XCTAssertEqual("Short-poem.txt", FileUtils.getSuggestedNewFilename(poemText: "Short poem"))
		XCTAssertEqual("Short-poem.txt", FileUtils.getSuggestedNewFilename(poemText: "Short poem"))
		XCTAssertEqual("leading-symbols.txt", FileUtils.getSuggestedNewFilename(poemText: ",! leading symbols"))
	}
}
