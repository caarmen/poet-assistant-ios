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
import Foundation

class UITestUtils {
	class func launchApp() -> XCUIApplication {
		let app = XCUIApplication()
		app.launchArguments = ["UITesting"]
		app.launch()
		return app
	}
	class func clearText(element: XCUIElement) {
		let text = element.value as! String
		// https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
		let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: text.count)
		element.typeText(deleteString)
	}
	
	class func openComposerTab(app:XCUIApplication) {
		openTab(app: app, position: 0)
	}
	class func openDictionariesTab(app:XCUIApplication) {
		openTab(app: app, position: 1)
	}
	
	class func openMore(app: XCUIApplication) {
		app.navigationBars.buttons.firstMatch.tap()
	}
	class func openSettings(app:XCUIApplication) {
		openMore(app: app)
		app.tables.cells.matching(identifier: "Settings").firstMatch.tap()
	}
	
	class func moveToRhymer(app:XCUIApplication) {
		moveToLexicon(app:app, position: 0)
	}
	class func moveToThesaurus(app:XCUIApplication) {
		moveToLexicon(app:app, position: 1)
	}
	class func moveToDictionary(app:XCUIApplication) {
		moveToLexicon(app:app, position:2)
	}
	class func moveToFavorites(app:XCUIApplication) {
		moveToLexicon(app:app, position:3)
	}
	private class func moveToLexicon(app:XCUIApplication, position: Int) {
		app.segmentedControls.buttons.element(boundBy: position).tap()
	}
	class func acceptDialog(app: XCUIApplication) {
		app.alerts.firstMatch.buttons.element(boundBy: 1).firstMatch.tap()
	}
	class func cancelDialog(app: XCUIApplication) {
		app.alerts.firstMatch.buttons.element(boundBy: 0).firstMatch.tap()
	}
	class func search(test: XCTestCase, app:XCUIApplication, query: String) {
		openDictionariesTab(app: app)
		let searchField = app.searchFields.firstMatch
		searchField.tap()
		searchField.typeText("\(query)\n")
		wait(test: test, timeout: 2)
	}
	
	class func waitForPlayButtonToHavePlayImage(test: XCTestCase, playButton: XCUIElement, timeout: TimeInterval) {
		waitForButtonToHaveImage(test: test, button: playButton, imageLabel: "ic play", timeout: timeout)
	}
	class func waitForPlayButtonToHaveStopImage(test: XCTestCase, playButton: XCUIElement, timeout: TimeInterval) {
		waitForButtonToHaveImage(test: test, button: playButton, imageLabel: "ic stop", timeout: timeout)
	}
	class func waitForButtonToHaveImage(test: XCTestCase, button: XCUIElement, imageLabel: String, timeout: TimeInterval) {
		let predicate = NSPredicate(format: "label == '\(imageLabel)'")
		test.expectation(for: predicate, evaluatedWith: button, handler: nil)
		test.waitForExpectations(timeout: timeout, handler: nil)
	}
	
	private class func openTab(app:XCUIApplication, position: Int) {
		let tabs = app.tabBars.firstMatch
		tabs.buttons.element(boundBy: position).tap()
	}
	class func waitFor (test: XCTestCase, timeout: TimeInterval, block: @escaping () -> Bool) {
		let condiationalExpectation  = test.expectation(description: "conditional expectation")
		DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + timeout) {
			if block() {
				condiationalExpectation.fulfill()
			}
		}
		test.wait(for: [condiationalExpectation], timeout: timeout + 0.5)
	}
	
	class func wait(test: XCTestCase, timeout: TimeInterval) {
		waitFor(test:test, timeout:timeout) {
			return true
		}
	}
	
	class func getRhymerHeader(app: XCUIApplication) -> XCUIElement {
		return getHeader(app:app, headerIdentifier: "RhymerResultHeader")
	}
	class func getThesaurusHeader(app: XCUIApplication) -> XCUIElement {
		return getHeader(app:app, headerIdentifier: "ThesaurusResultHeader")
	}
	class func getDictionaryHeader(app: XCUIApplication) -> XCUIElement {
		return getHeader(app:app, headerIdentifier: "DictionaryResultHeader")
	}
	private class func getHeader(app: XCUIApplication, headerIdentifier: String) -> XCUIElement {
		return app.otherElements.matching(identifier: headerIdentifier).firstMatch
	}
	class func waitForRTDToShow(test: XCTestCase, row: XCUIElement) {
		let dictionaryButton = row.buttons.matching(NSPredicate(format: "label == 'ic dictionary'")).firstMatch
		waitFor(test:test, timeout: 1.5) {
			return dictionaryButton.isHittable
		}
	}
	class func starWord(test: XCTestCase, app: XCUIApplication, word: String) {
		let row = app.cells
			.containing(NSPredicate(format: "label=%@", word))
			.firstMatch
		XCTAssert(row.isHittable)
		wait(test:test, timeout: 1) // Wait for RTD to be visible :(
		row.tap()
		waitForRTDToShow(test: test, row: row)
		row.buttons.matching(identifier: "ButtonFavorite").firstMatch.tap()
		wait(test:test, timeout: 1) // Wait for the screen to reload :(
	}
}
