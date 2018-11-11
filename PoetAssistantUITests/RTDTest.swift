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

class RTDTest: XCTestCase {
	
	struct RTDTestScenario {
		let query:String
		let firstRhyme:String
		let secondRhyme:String
		let firstSynonymForFirstRhyme:String
		let secondSynonymForFirstRhyme:String
		let firstDefinitionForSecondSynonym:String
	}
	private static let SCENARIO1 = RTDTestScenario(query:"howdy",
												   firstRhyme:"cloudy",
												   secondRhyme:"dowdy",
												   firstSynonymForFirstRhyme:"nebulose",
												   secondSynonymForFirstRhyme:"nebulous",
												   firstDefinitionForSecondSynonym:"lacking definite form or limits")
	private static let SCENARIO2 = RTDTestScenario(query:"beholden",
												   firstRhyme:"embolden",
												   secondRhyme:"golden",
												   firstSynonymForFirstRhyme:"hearten",
												   secondSynonymForFirstRhyme:"recreate",
												   firstDefinitionForSecondSynonym:"create anew")
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testRTDCleanLayoutTest1() {
		runRTDTest(data: RTDTest.SCENARIO1, efficientLayoutEnabled: false)
	}
	func testRTDCleanLayoutTest2() {
		runRTDTest(data: RTDTest.SCENARIO2, efficientLayoutEnabled: false)
	}
	func testRTDEfficientLayoutTest1() {
		runEfficientLayoutTest(scenario: RTDTest.SCENARIO1)
	}
	func testRTDEfficientLayoutTest2() {
		runEfficientLayoutTest(scenario: RTDTest.SCENARIO2)
	}
	
	private func runEfficientLayoutTest(scenario: RTDTestScenario) {
		chooseEfficientLayout()
		runRTDTest(data: scenario, efficientLayoutEnabled: true)
	}
	private func chooseEfficientLayout() {
		UITestUtils.openSettings(app: app)
		app.switches.matching(identifier: "SwitchRTD").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
	}
	private func runRTDTest(data: RTDTestScenario, efficientLayoutEnabled: Bool) {
		UITestUtils.search(test: self, app: app, query: data.query)
		tapHeaderButtons(header:UITestUtils.getRhymerHeader(app: app))
		UITestUtils.checkRhymes(app:app, query: data.query, expectedFirstRhyme: data.firstRhyme, expectedSecondRhyme: data.secondRhyme)
		
		openThesaurusFromRhymerCleanLayout(rhyme: data.firstRhyme, efficientLayoutEnabled: efficientLayoutEnabled)
		tapHeaderButtons(header:UITestUtils.getThesaurusHeader(app: app))

		checkSynonyms(query: data.query, expectedFirstSynonym: data.firstSynonymForFirstRhyme, expectedSecondSynonym: data.secondSynonymForFirstRhyme)
		
		openDictionaryFromThesaurusCleanLayout(synonym: data.secondSynonymForFirstRhyme, efficientLayoutEnabled: efficientLayoutEnabled)
		tapHeaderButtons(header:UITestUtils.getDictionaryHeader(app: app))
		checkDefinition(query: data.query, expectedFirstDefinition: data.firstDefinitionForSecondSynonym)
	}
	
	private func tapHeaderButtons(header: XCUIElement) {
		header.buttons.matching(identifier: "HeaderButtonPlay").firstMatch.tap()
		header.buttons.matching(identifier: "HeaderButtonLookup").firstMatch.tap()
		app.activate()
	}
	

	
	private func openThesaurusFromRhymerCleanLayout(rhyme: String, efficientLayoutEnabled: Bool) {
		let rhymerRow = app.cells.containing(NSPredicate(format: "label=%@", rhyme)).firstMatch
		if (!efficientLayoutEnabled) {
			rhymerRow.tap()
			UITestUtils.waitForRTDToShow(test:self, row: rhymerRow)
		}
		rhymerRow.buttons.matching(identifier: "ButtonThesaurus").firstMatch.tap()
		UITestUtils.wait(test: self, timeout: 2)
	}
	private func checkSynonyms(query: String, expectedFirstSynonym: String, expectedSecondSynonym:String) {
		let table = app.tables.element
		XCTAssertTrue(table.exists)
		let cell1 = table.cells.element(boundBy: 1)
		XCTAssertTrue(cell1.exists)
		let cell2 = table.cells.element(boundBy: 2)
		XCTAssertTrue(cell2.exists)
		// For some reason, on iPad, it takes a moment for the synonyms to become hittable.
		expectation(for: NSPredicate(format: "isHittable == true"), evaluatedWith: cell1.staticTexts.firstMatch, handler: nil)
		waitForExpectations(timeout: 2, handler: nil)
		XCTAssert(cell1.staticTexts[expectedFirstSynonym].isHittable)
		XCTAssert(cell2.staticTexts[expectedSecondSynonym].isHittable)
	}
	private func openDictionaryFromThesaurusCleanLayout(synonym: String, efficientLayoutEnabled: Bool) {
		let thesaurusRow = app.cells.containing(NSPredicate(format: "label=%@", synonym)).firstMatch
		if (!efficientLayoutEnabled) {
			thesaurusRow.tap()
			UITestUtils.waitForRTDToShow(test:self, row: thesaurusRow)
			thesaurusRow.tap()
			waitForRTDToHide(row: thesaurusRow)
			thesaurusRow.tap()
			UITestUtils.waitForRTDToShow(test:self, row: thesaurusRow)
		}
		thesaurusRow.buttons.matching(identifier: "ButtonDictionary").firstMatch.tap()
		UITestUtils.wait(test: self, timeout: 2)
	}
	private func checkDefinition(query: String, expectedFirstDefinition: String) {
		let definitionCellWordLabels = app.staticTexts.matching(identifier: "DictionaryCellDefinition")
		let actualDefinition = definitionCellWordLabels.element(boundBy: 0).label
		XCTAssertEqual(expectedFirstDefinition, actualDefinition, "Expected definition for \(query) to be \(expectedFirstDefinition) but got \(actualDefinition)")
	}

	private func waitForRTDToHide(row: XCUIElement) {
		let dictionaryButton = row.buttons.matching(NSPredicate(format: "label == 'ic dictionary'")).firstMatch
		UITestUtils.waitFor(test:self, timeout: 1.5) {
			return !(dictionaryButton.exists && dictionaryButton.isHittable)
		}
	}
}
