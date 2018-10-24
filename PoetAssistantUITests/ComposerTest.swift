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

class ComposerTest: XCTestCase {
	
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testHintAndPlayButton() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let labelHint = app.staticTexts.matching(identifier: "ComposerLabelHint").firstMatch
		let buttonPlay = app.buttons.matching(identifier: "ComposerButtonPlay").firstMatch
		assertVisible(element:textViewPoem)
		assertVisible(element:labelHint)
		assertVisible(element:buttonPlay)
		XCTAssertEqual("", textViewPoem.value as! String)
		XCTAssertFalse(buttonPlay.isEnabled)
		textViewPoem.tap()
		assertVisible(element:labelHint)
		let poemText = "Hello World"
		app.typeText(poemText)
		assertHidden(element:labelHint)
		XCTAssertTrue(buttonPlay.isEnabled)
		UITestUtils.clearText(element: textViewPoem)
		XCTAssertEqual("", textViewPoem.value as! String)
		assertVisible(element: labelHint)
		XCTAssertFalse(buttonPlay.isEnabled)
	}
	
	func testWordCount() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let labelWordCount = app.staticTexts.matching(identifier: "ComposerLabelWordCount").firstMatch
		assertVisible(element:textViewPoem)
		XCTAssertEqual("", textViewPoem.value as! String)
		assertHidden(element:labelWordCount)
		let poemText = "Hello World"
		textViewPoem.tap()
		app.typeText(poemText)
		assertVisible(element: labelWordCount)
		var wordCountText = labelWordCount.label
		XCTAssert(wordCountText.contains("2"))
		XCTAssert(wordCountText.contains("11"))
		UITestUtils.clearText(element: textViewPoem)
		assertHidden(element:labelWordCount)
		app.typeText(" ")
		assertHidden(element:labelWordCount)
		app.typeText(" 🙆🏻‍♀️ 👨🏽‍✈️")
		assertHidden(element:labelWordCount)
		app.typeText(" do you like emojis?")
		assertVisible(element:labelWordCount)
		wordCountText = labelWordCount.label
		XCTAssert(wordCountText.contains("4"))
		XCTAssert(wordCountText.contains("23"))
	}
	
	func testPlay() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let buttonPlay = app.buttons.matching(identifier: "ComposerButtonPlay").firstMatch
		textViewPoem.tap()
		app.typeText("Eeny meeny miney moe. Catch a tiger by the toe. If he hollers let him go. Eeny meeny miney moe.")
		let timestampBeforePlay = NSDate().timeIntervalSince1970
		buttonPlay.tap()
		UITestUtils.waitForPlayButtonToHaveStopImage(test: self, playButton: buttonPlay, timeout: 2)
		UITestUtils.waitForPlayButtonToHavePlayImage(test: self, playButton: buttonPlay, timeout: 15)
		let timestampAfterPlay = NSDate().timeIntervalSince1970
		// This poem should have taken at least 5 seconds to read.
		XCTAssertGreaterThan(timestampAfterPlay - timestampBeforePlay, 5)
		
		buttonPlay.tap()
		UITestUtils.waitForPlayButtonToHaveStopImage(test: self, playButton: buttonPlay, timeout: 1)
		buttonPlay.tap()
		UITestUtils.waitForPlayButtonToHavePlayImage(test: self, playButton: buttonPlay, timeout: 4)
	}
	
	func testKeyboard() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let buttonHideKeyboard = app.buttons.matching(identifier: "ComposerButtonHideKeyboard").firstMatch
		let tabs = app.tabBars.firstMatch
		assertVisible(element: textViewPoem)
		assertVisible(element: tabs)
		assertHidden(element: buttonHideKeyboard)
		textViewPoem.tap()
		textViewPoem.typeText("hello")
		assertHidden(element: tabs)
		assertVisible(element: buttonHideKeyboard)
		buttonHideKeyboard.tap()
		assertVisible(element: tabs)
		assertHidden(element: buttonHideKeyboard)
	}
	
	func testShare() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let buttonShare = app.buttons.matching(identifier: "ComposerButtonShare").firstMatch
		assertVisible(element:textViewPoem)
		assertVisible(element:buttonShare)
		XCTAssert(!buttonShare.isEnabled)
		textViewPoem.tap()
		textViewPoem.typeText("Hello there")
		XCTAssert(buttonShare.isEnabled)
		buttonShare.tap()
		let predicate = NSPredicate(format: "label =[cd] 'Cancel'")
		let buttonCancelShare = app.buttons.matching(predicate).firstMatch
		assertVisible(element: buttonCancelShare)
	}

	func testMenu() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let poemText = "Here is a poem"
		textViewPoem.tap()
		textViewPoem.typeText(poemText)
		let beginningPoint = textViewPoem.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
		beginningPoint.doubleTap()
		// Lookup "Here" in the rhymer (no localized string for Rhymer, from tests :( )
		openMenuItem(label:"Rhymer")
		XCTAssertEqual("here", UITestUtils.getRhymerQueryLabel(app:app).label)
		
		UITestUtils.openComposerTab(app:app)
		beginningPoint.tap()
		openMenuItem(label:"Thesaurus")
		XCTAssertEqual("here", UITestUtils.getThesaurusQueryLabel(app:app).label)
		
		UITestUtils.openComposerTab(app:app)
		beginningPoint.tap()
		openMenuItem(label:"Dictionary")
		XCTAssertEqual("here", UITestUtils.getDictionaryQueryLabel(app:app).label)
	}
	
	private func openMenuItem(label: String) {
		UITestUtils.wait(test: self, timeout: 0.5)
		let menuItem = app.menus.menuItems.matching(NSPredicate(format: "label == %@", label)).firstMatch
		if menuItem.exists {
			menuItem.tap()
		} else {
			let moreMenuItem = app.menus.menuItems.element(boundBy: app.menus.menuItems.count - 1).firstMatch
			moreMenuItem.tap()
			openMenuItem(label: label)
		}
	}

	private func assertVisible(element: XCUIElement) {
		let window = app.windows.element(boundBy: 0)
		XCTAssert(window.frame.contains(element.frame))
	}
	
	private func assertHidden(element: XCUIElement) {
		let window = app.windows.element(boundBy: 0)
		XCTAssert(!element.exists || !window.frame.contains(element.frame) || !element.isHittable)
	}
}