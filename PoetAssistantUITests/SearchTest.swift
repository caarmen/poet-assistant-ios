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

class SearchTest: XCTestCase {
	
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launchArguments = ["UITesting"]
		app.launch()
	}
	
	override func tearDown() {
	}
	
	func testSearchHistory() {
		let tabs = app.tabBars.firstMatch
		// Open the dictionaries tab
		tabs.buttons.element(boundBy: 1).tap()
		var searchField = app.searchFields.firstMatch
		
		searchField.typeText("carmen\n")
		searchField.tap()
		
		waitForSearchSuggestion(table: app.tables.firstMatch, texts: ["carmen"])
		
		searchField.tap()
		searchField.typeText("benoit\n")
		searchField.tap()
		waitForSearchSuggestion(table: app.tables.firstMatch, texts: ["benoit", "carmen"])
		
		searchField.typeText("awes")
		waitForSearchSuggestion(table: app.tables.firstMatch, texts: ["awesome", "awesomely", "awestruck"])
		
		searchField.typeText("o")
		waitForSearchSuggestion(table: app.tables.firstMatch, texts: ["awesome", "awesomely"])
		UITestUtils.clearText(element: searchField)
		
		searchField.typeText("carme")
		waitForSearchSuggestion(table: app.tables.firstMatch, texts: ["carmen", "carmelite"])

		searchField.tap()
		clearSearchHistory()
		
		searchField = app.navigationBars["PoetAssistant.SearchView"].searchFields.firstMatch
		searchField.tap()
		searchField.typeText("carme")
		waitForSearchSuggestion(table: app.tables.firstMatch, texts: ["carmelite"])
	}
	
	private func clearSearchHistory() {
		let deleteCell = app.tables.cells.matching(identifier: "cell_delete").firstMatch
		deleteCell.tap()
		let clearButton = app.alerts.firstMatch.buttons.element(boundBy: 1)
		clearButton.tap()
		waitForSearchHistoryDeletionDialogToDismiss()
	}
	
	private func waitForSearchHistoryDeletionDialogToDismiss() {
		let expectedDialogGone = expectation(description: "expected search history dialog gone")
		Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
			if !self.app.alerts.firstMatch.exists {
				expectedDialogGone.fulfill()
			}
			}.fire()
		wait(for: [expectedDialogGone], timeout: 3.0)
	}
	private func waitForSearchSuggestion(table: XCUIElement, texts: [String]) {
		let expectedSuggestionsExpectation = expectation(description: "expected suggestions")
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
			texts.forEach { text in
				if !table.staticTexts[text].firstMatch.exists {
					return
				}
			}
			expectedSuggestionsExpectation.fulfill()
			}.fire()
		wait(for: [expectedSuggestionsExpectation], timeout: 2.0)
	}
	
}
