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

		//searchField.tap()
		searchField.typeText("carmen\n")
		searchField.tap()
		waitForSearchSuggestion(searchField: searchField, table:app.tables.firstMatch, query: "", expectedSuggestions: ["carmen"], expectedClearHistory: true)
		
		//searchField.tap()
		searchField.typeText("benoit\n")
		
		searchField.tap()
		waitForSearchSuggestion(searchField: searchField, table: app.tables.firstMatch, query: "", expectedSuggestions: ["benoit", "carmen"], expectedClearHistory: true)
		
		waitForSearchSuggestion(searchField: searchField, table: app.tables.firstMatch, query: "awes", expectedSuggestions: ["awesome", "awesomely", "awestruck"], expectedClearHistory: false)
		
		waitForSearchSuggestion(searchField: searchField, table: app.tables.firstMatch, query: "o", expectedSuggestions: ["awesome", "awesomely"], expectedClearHistory: false)
		UITestUtils.clearText(element: searchField)
		searchField.tap()
		waitForSearchSuggestion(searchField: searchField, table: app.tables.firstMatch, query: "carme", expectedSuggestions: ["carmen", "carmelite"], expectedClearHistory: true)

		//searchField.tap()
		clearSearchHistory()
		
		searchField = app.navigationBars["PoetAssistant.SearchView"].searchFields.firstMatch
		searchField.tap()
		waitForSearchSuggestion(searchField: searchField, table: app.tables.firstMatch, query: "carme", expectedSuggestions: ["carmelite"], expectedClearHistory: false)
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
		DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 3.0) {
			if !self.app.alerts.firstMatch.exists {
				expectedDialogGone.fulfill()
			}
		}
		wait(for: [expectedDialogGone], timeout: 3.5)
	}
	private func waitForSearchSuggestion(searchField: XCUIElement, table: XCUIElement, query: String, expectedSuggestions: [String], expectedClearHistory: Bool) {
		searchField.typeText(query)
		let expectedSuggestionsExpectation = expectation(description: "expected suggestions")
		DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 1.5) {
			// If there are any suggestions, there will also be an additional row item to clear history
			let expectedSuggestionCount = expectedClearHistory ? expectedSuggestions.count + 1 : expectedSuggestions.count
			let actualSuggestionTitles = table.staticTexts.matching(identifier: "SuggestionTitle")
			XCTAssertEqual(expectedSuggestionCount, actualSuggestionTitles.count, "Expected \(expectedSuggestionCount) suggestions but got \(actualSuggestionTitles.count) for \(query)")
			expectedSuggestions.forEach { suggestion in
				XCTAssert(table.staticTexts[suggestion].exists, "Didn't find expected suggestion \(suggestion) for \(query)")
			}
			expectedSuggestionsExpectation.fulfill()
		}
		wait(for: [expectedSuggestionsExpectation], timeout: 2.0)
	}
	
}
