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

class SearchResultAssertions {
	class func assertRhymes(app:XCUIApplication, query: String, expectedFirstRhyme: String, expectedSecondRhyme: String) {
		let table = app.tables.firstMatch
		XCTAssertTrue(table.exists)
		let cell0 = table.cells.staticTexts.matching(NSPredicate(format: "label = %@", expectedFirstRhyme)).firstMatch
		XCTAssertTrue(cell0.exists)
		let cell1 = table.cells.staticTexts.matching(NSPredicate(format: "label = %@", expectedSecondRhyme)).firstMatch
		XCTAssertTrue(cell1.exists)
		
		// We query for the first cells that we find with the expected rhymes,
		// instead of directly accessing the 1st and 2nd cells in the table,
		// for performance issues.
		// So we can't add assertions for the "first" and "second" rhymes.
		// But we can at least add assertions that both rhymes are visible,
		// and the first one is above the second one.
		XCTAssertTrue(cell0.frame.minY < cell1.frame.minY)
		XCTAssertTrue(cell0.isHittable)
		XCTAssertTrue(cell1.isHittable)
	}
	class func assertSynonyms(test: XCTestCase, app:XCUIApplication, query: String, expectedFirstSynonym: String, expectedSecondSynonym:String) {
		let table = app.tables.element
		XCTAssertTrue(table.exists)
		let cell1 = table.cells.element(boundBy: 1)
		XCTAssertTrue(cell1.exists)
		let cell2 = table.cells.element(boundBy: 2)
		XCTAssertTrue(cell2.exists)
		// For some reason, on iPad, it takes a moment for the synonyms to become hittable.
		test.expectation(for: NSPredicate(format: "isHittable == true"), evaluatedWith: cell1.staticTexts.firstMatch, handler: nil)
		test.waitForExpectations(timeout: 2, handler: nil)
		XCTAssert(cell1.staticTexts[expectedFirstSynonym].isHittable)
		XCTAssert(cell2.staticTexts[expectedSecondSynonym].isHittable)
	}
	class func assertDefinition(app: XCUIApplication, query: String, expectedFirstDefinition: String) {
		let definitionCellWordLabels = app.staticTexts.matching(identifier: "DictionaryCellDefinition")
		let actualDefinition = definitionCellWordLabels.element(boundBy: 0).label
		XCTAssertEqual(expectedFirstDefinition, actualDefinition, "Expected definition for \(query) to be \(expectedFirstDefinition) but got \(actualDefinition)")
	}
}
