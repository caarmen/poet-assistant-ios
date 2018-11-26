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
		UITestUtils.assertVisible(app:app, element:textViewPoem)
		UITestUtils.assertVisible(app:app, element:labelHint)
		UITestUtils.assertVisible(app:app, element:buttonPlay)
		XCTAssertEqual("", textViewPoem.value as! String)
		XCTAssertFalse(buttonPlay.isEnabled)
		textViewPoem.tap()
		UITestUtils.assertVisible(app:app, element:labelHint)
		let poemText = "Hello World"
		app.typeText(poemText)
		UITestUtils.assertHidden(app:app, element:labelHint)
		XCTAssertTrue(buttonPlay.isEnabled)
		UITestActions.clearText(element: textViewPoem)
		XCTAssertEqual("", textViewPoem.value as! String)
		UITestUtils.assertVisible(app:app, element: labelHint)
		XCTAssertFalse(buttonPlay.isEnabled)
	}
	
	func testWordCount() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let labelWordCount = app.staticTexts.matching(identifier: "ComposerLabelWordCount").firstMatch
		UITestUtils.assertVisible(app:app, element:textViewPoem)
		XCTAssertEqual("", textViewPoem.value as! String)
		UITestUtils.assertHidden(app:app, element:labelWordCount)
		let poemText = "Hello World"
		textViewPoem.tap()
		app.typeText(poemText)
		UITestUtils.assertVisible(app:app, element: labelWordCount)
		var wordCountText = labelWordCount.label
		XCTAssert(wordCountText.contains("2"))
		XCTAssert(wordCountText.contains("11"))
		UITestActions.clearText(element: textViewPoem)
		UITestUtils.assertHidden(app:app, element:labelWordCount)
		app.typeText(" ")
		UITestUtils.assertHidden(app:app, element:labelWordCount)
		app.typeText(" 🙆🏻‍♀️ 👨🏽‍✈️")
		UITestUtils.assertHidden(app:app, element:labelWordCount)
		app.typeText(" do you like emojis?")
		UITestUtils.assertVisible(app:app, element:labelWordCount)
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
		UITestWaitHacks.waitForPlayButtonToHaveStopImage(test: self, playButton: buttonPlay, timeout: 2)
		UITestWaitHacks.waitForPlayButtonToHavePlayImage(test: self, playButton: buttonPlay, timeout: 15)
		let timestampAfterPlay = NSDate().timeIntervalSince1970
		// This poem should have taken at least 5 seconds to read.
		XCTAssertGreaterThan(timestampAfterPlay - timestampBeforePlay, 5)
		
		buttonPlay.tap()
		UITestWaitHacks.waitForPlayButtonToHaveStopImage(test: self, playButton: buttonPlay, timeout: 1)
		buttonPlay.tap()
		UITestWaitHacks.waitForPlayButtonToHavePlayImage(test: self, playButton: buttonPlay, timeout: 4)
	}
	
	func testKeyboard() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let buttonHideKeyboard = app.buttons.matching(identifier: "ComposerButtonHideKeyboard").firstMatch
		let tabs = app.tabBars
		UITestUtils.assertVisible(app:app, element: textViewPoem)
		UITestUtils.assertVisible(app:app, element: tabs.firstMatch)
		UITestUtils.assertHidden(app:app, element: buttonHideKeyboard)
		UITestUtils.assertHidden(app:app, element: app.keyboards.firstMatch)
		textViewPoem.tap()
		textViewPoem.typeText("hello")
		UITestUtils.assertVisible(app:app, element: app.keyboards.firstMatch)
		UITestUtils.assertVisible(app:app, element: buttonHideKeyboard)
		buttonHideKeyboard.tap()
		UITestUtils.assertVisible(app:app, element: tabs.firstMatch)
		UITestUtils.assertHidden(app:app, element: buttonHideKeyboard)
		UITestUtils.assertHidden(app:app, element: app.keyboards.firstMatch)
	}
	
	func testMenu() {
		let headerWord = app.staticTexts.matching(identifier: "HeaderWord")
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		let poemText = "Here is a poem"
		textViewPoem.tap()
		textViewPoem.typeText(poemText)
		let beginningPoint = textViewPoem.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
		beginningPoint.doubleTap()
		// Lookup "Here" in the rhymer (no localized string for Rhymer, from tests :( )
		openMenuItem(label:"Rhymer")
		XCTAssertEqual("here", headerWord.firstMatch.label)
		
		UITestNavigation.openComposerTab(app:app)
		beginningPoint.tap()
		openMenuItem(label:"Thesaurus")
		XCTAssertEqual("here", headerWord.firstMatch.label)
		
		UITestNavigation.openComposerTab(app:app)
		beginningPoint.tap()
		openMenuItem(label:"Dictionary")
		XCTAssertEqual("here", headerWord.firstMatch.label)
	}
	
	private func openMenuItem(label: String) {
		UITestWaitHacks.wait(test: self, timeout: 0.5)
		let menuItem = app.menus.menuItems.matching(NSPredicate(format: "label == %@", label)).firstMatch
		if menuItem.exists {
			menuItem.tap()
		} else {
			let moreMenuItem = app.menus.menuItems.element(boundBy: app.menus.menuItems.count - 1).firstMatch
			moreMenuItem.tap()
			openMenuItem(label: label)
		}
	}
}
