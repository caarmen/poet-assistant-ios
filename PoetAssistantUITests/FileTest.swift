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

class FileTest: XCTestCase {
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testNewFile() {
		let poemText = "Hello World"
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem")
		typePoem(textViewPoem: textViewPoem, poemText: poemText)
		cancelFileOperation(fileOperation: "New", newFilename: "my poem")
		XCTAssertEqual(poemText, textViewPoem.firstMatch.value as! String)
		expectNavigationBarTitle(expectedTitle: "Poem")
		acceptFileOperation(fileOperation: "New", newFilename: "my poem")
		XCTAssertEqual("", textViewPoem.firstMatch.value as! String)
		expectNavigationBarTitle(expectedTitle: "My Poem")
	}
	
	func testSaveAs() {
		let poemText = "Hello World"
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem")
		typePoem(textViewPoem: textViewPoem, poemText: poemText)
		cancelFileOperation(fileOperation: "SaveAs", newFilename: "my poem")
		XCTAssertEqual(poemText, textViewPoem.firstMatch.value as! String)
		expectNavigationBarTitle(expectedTitle: "Poem")
		acceptFileOperation(fileOperation: "SaveAs", newFilename: "my poem")
		XCTAssertEqual(poemText, textViewPoem.firstMatch.value as! String)
		expectNavigationBarTitle(expectedTitle: "My Poem")
	}
	
	private func cancelFileOperation(fileOperation: String, newFilename: String) {
		UITestUtils.openMore(app:app)
		app.tables.cells.matching(identifier: fileOperation).firstMatch.tap()
		// enter a new poem name but cancel
		app.textFields.firstMatch.typeText(newFilename)
		UITestUtils.cancelDialog(app:app)
		app.navigationBars.buttons.firstMatch.tap()
	}
	
	private func acceptFileOperation(fileOperation: String, newFilename: String) {
		UITestUtils.openMore(app:app)
		app.tables.cells.matching(identifier: fileOperation).firstMatch.tap()
		app.textFields.firstMatch.typeText(newFilename)
		UITestUtils.acceptDialog(app:app)
	}
	
	private func typePoem(textViewPoem: XCUIElementQuery, poemText: String) {
		textViewPoem.firstMatch.tap()
		app.typeText(poemText)
		XCTAssertEqual(poemText, textViewPoem.firstMatch.value as! String)
	}
	
	private func expectNavigationBarTitle(expectedTitle: String) {
		let navigationBar = app.navigationBars.matching(identifier: expectedTitle)
		UITestUtils.waitFor(test: self, timeout: 0.5) {
			return navigationBar.firstMatch.exists
				&& navigationBar.firstMatch.isHittable
		}
	}
}
