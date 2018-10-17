//
//  WordCountTest.swift
//  PoetAssistantTests
//
//  Created by Carmen Alvarez on 07/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import XCTest
@testable import PoetAssistant

class WordCountTest: XCTestCase {
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testEmpty() {
		XCTAssertEqual(0, WordCounter.countWords(text: ""))
		XCTAssertEqual(0, WordCounter.countCharacters(text: ""))
	}
	
	func testSimpleSentence() {
		let text = "See spot run."
		XCTAssertEqual(3, WordCounter.countWords(text:text))
		XCTAssertEqual(13, WordCounter.countCharacters(text:text))
	}
	
	func testApostrophe() {
		let text = "I can't even";
		XCTAssertEqual(3, WordCounter.countWords(text:text));
		XCTAssertEqual(12, WordCounter.countCharacters(text:text));
	}
	
	func testTaleOfTwoCities() {
		let text = "we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way— in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.";
		XCTAssertEqual(59, WordCounter.countWords(text:text));
		XCTAssertEqual(325, WordCounter.countCharacters(text:text));
	}
	
	func testNewline() {
		let text = "foo\nbar"
		XCTAssertEqual(2, WordCounter.countWords(text:text));
		XCTAssertEqual(7, WordCounter.countCharacters(text:text));
	}
	func testHuckleberryFinn() {
		let text = "“Did I give you the letter?”\n" +
			"“What letter?”\n" +
			"“The one I got yesterday out of the post-office.”\n" +
			"“No, you didn’t give me no letter.”\n" +
		"“Well, I must a forgot it.”";
		XCTAssertEqual(30, WordCounter.countWords(text:text));
		XCTAssertEqual(157, WordCounter.countCharacters(text:text));
	}
	
	func testWarAndPeace() {
		let text = "The count came waddling in to see his wife with a rather guilty look as usual.\n" +
		"“Well, little countess? What a sauté of game au madère we are to have, my dear! I tasted it. The thousand rubles I paid for Tarás were not ill-spent. He is worth it!”";
		XCTAssertEqual(49, WordCounter.countWords(text:text));
		XCTAssertEqual(245, WordCounter.countCharacters(text:text));
	}
	
	func testShakespeare() {
		let text = "Where wasteful Time debateth with decay\n" +
			"To change your day of youth to sullied night,\n" +
			"   And all in war with Time for love of you,\n" +
		"   As he takes from you, I engraft you new.\n";
		XCTAssertEqual(34, WordCounter.countWords(text:text));
		XCTAssertEqual(175, WordCounter.countCharacters(text:text));
	}
	
	
	func testDracula() {
		let text = "4 May.—I found that my landlord had got a letter from the Count";
		XCTAssertEqual(14, WordCounter.countWords(text:text));
		XCTAssertEqual(63, WordCounter.countCharacters(text:text));
	}
	
	func testImportanceEarnest() {
		let text = "Algernon.  And, speaking of the science of Life, have you got the cucumber sandwiches cut for Lady Bracknell?\n" +
			"\n" +
		"Lane.  Yes, sir.  [Hands them on a salver.]";
		XCTAssertEqual(26, WordCounter.countWords(text:text));
		XCTAssertEqual(154, WordCounter.countCharacters(text:text));
	}
	
	func testDate1() {
		let text = "On the 5th of November, I wrote this test.";
		XCTAssertEqual(9, WordCounter.countWords(text:text));
		XCTAssertEqual(42, WordCounter.countCharacters(text:text));
	}
	
	func testDate2() {
		let text = "On 11/5/2017, I wrote this test.";
		XCTAssertEqual(8, WordCounter.countWords(text:text));
		XCTAssertEqual(32, WordCounter.countCharacters(text:text));
	}
	
	func testEmojis() {
		let text = "one 123👨🏽‍✈️ 456"
		XCTAssertEqual(3, WordCounter.countWords(text:text));
		XCTAssertEqual(11, WordCounter.countCharacters(text:text));
	}
	
	func testEmojis2() {
		let text = "one 123👨🏽‍✈️👨🏻‍⚖️ 456"
		XCTAssertEqual(3, WordCounter.countWords(text:text));
		XCTAssertEqual(11, WordCounter.countCharacters(text:text));
	}
	
	func testEmojis3() {
		let text = "one 123 👨🏽‍✈️👨🏻‍⚖️ 456"
		XCTAssertEqual(3, WordCounter.countWords(text:text));
		XCTAssertEqual(12, WordCounter.countCharacters(text:text));
	}
	
	func testEmojis4() {
		let text = "one 1👨🏽‍✈️23 👨🏻‍⚖️ 456"
		XCTAssertEqual(3, WordCounter.countWords(text:text));
		XCTAssertEqual(12, WordCounter.countCharacters(text:text));
	}
	
	
}
