//
//  FileTest.swift
//  PoetAssistantUITests
//
//  Created by Carmen Alvarez on 27/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

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
