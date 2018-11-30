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

class WordNotFoundTest: XCTestCase {
	
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testSimilarWordFound() {
		UITestActions.search(test: self, app: app, query: "animations")

		let headerQueryWord = app.staticTexts.matching(identifier: "HeaderWord")
		UITestNavigation.moveToRhymer(app:app)
		assertSearchHasResults(minResultCount: 10, queryLabelElement: headerQueryWord.firstMatch, emptyTextElement: getRhymerEmptyText(), expectedQueryLabelValue: "animations")
		
		UITestNavigation.moveToThesaurus(app:app)
		assertSearchHasResults(minResultCount: 10, queryLabelElement: headerQueryWord.firstMatch, emptyTextElement: getThesaurusEmptyText(), expectedQueryLabelValue: "animation")
		
		UITestNavigation.moveToDictionary(app:app)
		assertSearchHasResults(minResultCount: 6, queryLabelElement: headerQueryWord.firstMatch, emptyTextElement: getDictionaryEmptyText(), expectedQueryLabelValue: "animation")
	}
	
	func testNoSimilarWordFound() {
		UITestActions.search(test:self, app: app, query: "qsdfasdf")

		UITestNavigation.moveToRhymer(app:app)
		assertSearchHasNoResults(header: UITestUtils.getRhymerHeader(app:app), emptyTextLabel: getRhymerEmptyText())
		
		UITestNavigation.moveToThesaurus(app:app)
		assertSearchHasNoResults(header: UITestUtils.getThesaurusHeader(app:app), emptyTextLabel: getThesaurusEmptyText())

		UITestNavigation.moveToDictionary(app:app)
		assertSearchHasNoResults(header: UITestUtils.getDictionaryHeader(app:app), emptyTextLabel: getDictionaryEmptyText())
	}
	private func getRhymerEmptyText() -> XCUIElement {
		return getEmptyText(identifier: "RhymerEmptyText")
	}
	private func getThesaurusEmptyText() -> XCUIElement {
		return getEmptyText(identifier: "ThesaurusEmptyText")
	}
	private func getDictionaryEmptyText() -> XCUIElement {
		return getEmptyText(identifier: "DictionaryEmptyText")
	}
	private func getEmptyText(identifier: String) -> XCUIElement {
		return app.staticTexts.matching(identifier: identifier).firstMatch
	}
	private func assertNoRhymerQueryLabel() {
		XCTAssertFalse(UITestUtils.getRhymerHeader(app:app).firstMatch.exists)
	}
	private func assertNoThesaurusQueryLabel() {
		XCTAssertFalse(UITestUtils.getThesaurusHeader(app:app).firstMatch.exists)
	}
	private func assertNoDictionaryQueryLabel() {
		XCTAssertFalse(UITestUtils.getDictionaryHeader(app:app).firstMatch.exists)
	}

	private func assertSearchHasResults(minResultCount: Int, queryLabelElement: XCUIElement, emptyTextElement: XCUIElement, expectedQueryLabelValue: String) {
		XCTAssert(queryLabelElement.exists)
		XCTAssert(queryLabelElement.isHittable)
		XCTAssertEqual(expectedQueryLabelValue, queryLabelElement.label)
		
		let table = app.tables.firstMatch
		XCTAssert(table.exists)
		XCTAssert(table.isHittable)
		XCTAssertGreaterThanOrEqual(table.cells.count, minResultCount)
		
		XCTAssertFalse(emptyTextElement.exists)
	}
	private func assertSearchHasNoResults(header: XCUIElement, emptyTextLabel: XCUIElement) {
		let table = app.tables.firstMatch
		XCTAssert(table.exists)
		XCTAssertEqual(0, table.cells.count)
		XCTAssertFalse(header.exists)
		XCTAssert(emptyTextLabel.exists)
		XCTAssert(emptyTextLabel.isHittable)
	}
	
}
