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
	
	func testNewFileSameName() {
		let poemText = "Hello World"
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem")
		typePoem(textViewPoem: textViewPoem, poemText: poemText)
		acceptFileOperation(fileOperation: "New", newFilename: "my poem")
		XCTAssertEqual("", textViewPoem.firstMatch.value as! String)
		typePoem(textViewPoem: textViewPoem, poemText: "roses are red")
		acceptFileOperation(fileOperation: "New", newFilename: "my poem")
		XCTAssertEqual("", textViewPoem.firstMatch.value as! String)
	}
	func testSaveAsSameName() {
		let poemText = "Hello World"
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem")
		typePoem(textViewPoem: textViewPoem, poemText: poemText)
		acceptFileOperation(fileOperation: "SaveAs", newFilename: "my poem")
		XCTAssertEqual(poemText, textViewPoem.firstMatch.value as! String)
		let newPoemText = "Roses are red"
		typePoem(textViewPoem: textViewPoem, poemText: newPoemText)
		acceptFileOperation(fileOperation: "SaveAs", newFilename: "my poem")
		XCTAssertEqual("\(poemText)\(newPoemText)", textViewPoem.firstMatch.value as! String)
	}
	private func cancelFileOperation(fileOperation: String, newFilename: String) {
		UITestUtils.openMore(app:app)
		app.tables.cells.matching(identifier: fileOperation).firstMatch.tap()
		// enter a new poem name but cancel
		typeFilenameInPrompt(textFieldFilename: app.textFields.firstMatch, newValue: newFilename)
		UITestUtils.cancelDialog(app:app)
		app.navigationBars.buttons.firstMatch.tap()
	}
	
	private func acceptFileOperation(fileOperation: String, newFilename: String) {
		UITestUtils.openMore(app:app)
		app.tables.cells.matching(identifier: fileOperation).firstMatch.tap()
		typeFilenameInPrompt(textFieldFilename: app.textFields.firstMatch, newValue: newFilename)
		UITestUtils.acceptDialog(app:app)
	}
	
	private func typeFilenameInPrompt(textFieldFilename: XCUIElement, newValue: String) {
		let prefilledFilename = textFieldFilename.value as! String
		XCTAssert(prefilledFilename.hasPrefix("poem-"))
		XCTAssert(prefilledFilename.hasSuffix(".txt"))
		UITestUtils.clearText(element: textFieldFilename)
		textFieldFilename.typeText(newValue)
	}
	
	private func typePoem(textViewPoem: XCUIElementQuery, poemText: String) {
		let initialText = textViewPoem.firstMatch.value as! String
		let matchedTextView = textViewPoem.firstMatch
		let textViewFrame = matchedTextView.frame
		// Tap at the end of the TextView
		app.coordinate(withNormalizedOffset: CGVector.zero)
			.withOffset(
				CGVector(
					dx:textViewFrame.origin.x + textViewFrame.size.width - 1,
					dy:textViewFrame.origin.y + textViewFrame.size.height - 1))
			.tap()
		app.typeText(poemText)
		XCTAssertEqual("\(initialText)\(poemText)", textViewPoem.firstMatch.value as! String)
	}
	
	private func expectNavigationBarTitle(expectedTitle: String) {
		let navigationBar = app.navigationBars.matching(identifier: expectedTitle)
		UITestUtils.waitFor(test: self, timeout: 1.0) {
			return navigationBar.firstMatch.exists
				&& navigationBar.firstMatch.isHittable
		}
	}
}
