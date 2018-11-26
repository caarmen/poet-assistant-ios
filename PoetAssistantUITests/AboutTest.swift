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

class AboutTest: XCTestCase {
	
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testAbout() {
		UITestNavigation.openMore(app: app)
		let aboutElement = app.tables.cells.matching(identifier: "About").firstMatch
		XCTAssert(aboutElement.exists)
		XCTAssert(aboutElement.isHittable)
		aboutElement.tap()
		["AboutSource", "AboutBugs", "AboutPrivacyPolicy", "AboutLicense", "AboutRhymerLicense",
		 "AboutThesaurusLicense", "AboutDictionaryLicense", "AboutPorterStemmer"].forEach {
			tapAboutListItem(identifier: $0)
		}
	}
	private func tapAboutListItem(identifier: String) {
		let element = app.tables.cells.matching(identifier: identifier).firstMatch
		UITestWaitHacks.waitFor(test:self, timeout:0.5) {
			element.exists && element.isHittable
		}
		element.tap()
		app.activate()
	}
}
