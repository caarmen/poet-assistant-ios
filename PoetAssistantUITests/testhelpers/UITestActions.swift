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

class UITestActions {
	class func clearText(element: XCUIElement) {
		let text = element.value as! String
		// https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
		let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: text.count)
		element.typeText(deleteString)
	}
	
	class func acceptDialog(app: XCUIApplication) {
		app.alerts.firstMatch.buttons.element(boundBy: 1).firstMatch.tap()
	}
	class func cancelDialog(app: XCUIApplication) {
		app.alerts.firstMatch.buttons.element(boundBy: 0).firstMatch.tap()
	}
	
	class func search(test: XCTestCase, app:XCUIApplication, query: String) {
		UITestNavigation.openDictionariesTab(app: app)
		let searchField = app.searchFields.firstMatch
		searchField.tap()
		searchField.typeText("\(query)\n")
		UITestWaitHacks.wait(test: test, timeout: 2)
	}
	class func starWord(test: XCTestCase, app: XCUIApplication, word: String) {
		let row = app.cells
			.containing(NSPredicate(format: "label=%@", word))
			.firstMatch
		UITestWaitHacks.wait(test:test, timeout: 1) // Wait for RTD to be visible :(
		XCTAssert(row.isHittable)
		row.tap()
		UITestWaitHacks.waitForRTDToShow(test: test, row: row)
		row.buttons.matching(identifier: "ButtonFavorite").firstMatch.tap()
		UITestWaitHacks.wait(test:test, timeout: 1) // Wait for the screen to reload :(
	}
}
