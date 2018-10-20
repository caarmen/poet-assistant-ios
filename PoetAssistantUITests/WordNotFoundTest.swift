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
		UITestUtils.search(test: self, app: app, query: "animations")

		moveToRhymer()
		assertSearchHasResults(minResultCount: 10, queryLabelElement: getRhymerQueryLabel(), emptyTextElement: getRhymerEmptyText(), expectedQueryLabelValue: "animations")
		
		moveToThesaurus()
		assertSearchHasResults(minResultCount: 10, queryLabelElement: getThesaurusQueryLabel(), emptyTextElement: getThesaurusEmptyText(), expectedQueryLabelValue: "animation")
		
		moveToDictionary()
		assertSearchHasResults(minResultCount: 6, queryLabelElement: getDictionaryQueryLabel(), emptyTextElement: getDictionaryEmptyText(), expectedQueryLabelValue: "animation")
	}
	
	func testNoSimilarWordFound() {
		UITestUtils.search(test:self, app: app, query: "qsdfasdf")

		moveToRhymer()
		assertSearchHasNoResults(header: getRhymerHeader(), emptyTextLabel: getRhymerEmptyText())
		
		moveToThesaurus()
		assertSearchHasNoResults(header: getThesaurusHeader(), emptyTextLabel: getThesaurusEmptyText())

		moveToDictionary()
		assertSearchHasNoResults(header: getDictionaryHeader(), emptyTextLabel: getDictionaryEmptyText())
	}
	
	private func assertNoRhymerQueryLabel() {
		XCTAssertFalse(getRhymerHeader().firstMatch.exists)
	}
	private func assertNoThesaurusQueryLabel() {
		XCTAssertFalse(getThesaurusHeader().firstMatch.exists)
	}
	private func assertNoDictionaryQueryLabel() {
		XCTAssertFalse(getDictionaryHeader().firstMatch.exists)
	}
	
	private func getRhymerQueryLabel() -> XCUIElement {
		return getResultHeaderQueryLabel(header:getRhymerHeader(), queryLabelIdentifier: "RhymerQueryLabel")
	}
	private func getThesaurusQueryLabel()-> XCUIElement {
		return getResultHeaderQueryLabel(header:getThesaurusHeader(), queryLabelIdentifier: "ThesaurusQueryLabel")
	}
	private func getDictionaryQueryLabel()-> XCUIElement {
		return getResultHeaderQueryLabel(header:getDictionaryHeader(), queryLabelIdentifier: "DictionaryQueryLabel")
	}
	
	private func getRhymerHeader() -> XCUIElement {
		return getHeader(headerIdentifier: "RhymerResultHeader")
	}
	private func getThesaurusHeader() -> XCUIElement {
		return getHeader(headerIdentifier: "ThesaurusResultHeader")
	}
	private func getDictionaryHeader() -> XCUIElement {
		return getHeader(headerIdentifier: "DictionaryResultHeader")
	}
	private func getHeader(headerIdentifier: String) -> XCUIElement {
		return app.otherElements.matching(identifier: headerIdentifier).firstMatch
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
	
	private func getResultHeaderQueryLabel(header: XCUIElement, queryLabelIdentifier: String) -> XCUIElement {
		return header
			.staticTexts.matching(identifier: queryLabelIdentifier)
			.firstMatch
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
	
	private func moveToRhymer() {
		moveToLexicon(position: 0)
	}
	private func moveToThesaurus() {
		moveToLexicon(position: 1)
	}
	private func moveToDictionary() {
		moveToLexicon(position:2)
	}
	private func moveToLexicon(position: Int) {
		app.segmentedControls.buttons.element(boundBy: position).tap()
	}
	
}
