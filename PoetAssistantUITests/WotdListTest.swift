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

class WotdListTest: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}

    func testWotdList() {
		UITestNavigation.openMore(app:app)
		let wotdElement = app.tables.cells.matching(identifier: "Wotd").firstMatch
		XCTAssert(wotdElement.exists)
		XCTAssert(wotdElement.isHittable)
		wotdElement.tap()
		app.tables.cells.firstMatch.tap()
		let dictionaryTab = app.segmentedControls.buttons.element(boundBy: 2)
		XCTAssertTrue(dictionaryTab.exists)
		XCTAssertTrue(dictionaryTab.isSelected)
		let definitionCellWordLabels = app.staticTexts.matching(identifier: "DictionaryCellDefinition").firstMatch
		UITestWaitHacks.waitForElementToExist(test: self, element: definitionCellWordLabels, timeout: 1.0)
		XCTAssertFalse(definitionCellWordLabels.label.isEmpty)
    }

}
