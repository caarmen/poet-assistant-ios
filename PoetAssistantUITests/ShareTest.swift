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

class ShareTest: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testSharePoem() {
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem")
		UITestUtils.assertVisible(app:app, element:textViewPoem.firstMatch)
		UITestUtils.openMore(app: app)
		let shareQuery = app.tables.cells.matching(identifier: "Share")
		XCTAssert(shareQuery.firstMatch.frame.height < 1)
		app.navigationBars.buttons.firstMatch.tap()
		textViewPoem.firstMatch.tap()
		textViewPoem.firstMatch.typeText("Hello there")
		UITestUtils.openMore(app: app)
		XCTAssert(shareQuery.firstMatch.frame.height > 1)
		shareQuery.firstMatch.tap()
		let predicate = NSPredicate(format: "label =[cd] 'Cancel'")
		let buttonCancelShare = app.buttons.matching(predicate).firstMatch
		if UIDevice.current.userInterfaceIdiom == .phone {
			UITestUtils.assertVisible(app: app, element: buttonCancelShare)
		} else {
			XCTAssertFalse(buttonCancelShare.exists)
		}
	}

	func testShareRhymer() {
		UITestUtils.search(test: self, app: app, query: "merge")
		UITestUtils.moveToRhymer(app: app)
		testShare(expectedShareTexts: "berge", "upsurge")
	}
	
	func testShareThesaurus() {
		UITestUtils.search(test: self, app: app, query: "happy")
		UITestUtils.moveToThesaurus(app: app)
		testShare(expectedShareTexts: "halcyon", "well-chosen")
	}
	
	func testShareDictionary() {
		UITestUtils.search(test: self, app: app, query: "a")
		UITestUtils.moveToDictionary(app: app)
		testShare(expectedShareTexts: "purine base found in DNA and RNA", "the blood group whose red cells carry the A antigen")
	}

	private func testShare(expectedShareTexts: String...) {
		app.buttons.matching(identifier: "HeaderButtonShare").firstMatch.tap()
		app.buttons["Copy"].tap()
		UITestUtils.openComposerTab(app: app)
		let poemTextView = app.textViews.firstMatch
		poemTextView.press(forDuration: 1.0)
		app.menuItems["Paste"].tap()
		UITestUtils.waitFor(test:self, timeout: 1.0) {
			let poemText = poemTextView.value as! String
			for i in 0..<expectedShareTexts.count {
				if !poemText.contains(expectedShareTexts[i]) {
					return false
				}
			}
			return true
		}
	}
}
