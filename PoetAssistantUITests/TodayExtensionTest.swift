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

class TodayExtensionTest: XCTestCase {
	
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testWidget() {
		let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
		WidgetUtils.createWidget(test: self, springboard: springboard)
		testExpandCollapse(springboard: springboard)
	}

	private func testExpandCollapse(springboard: XCUIApplication) {
		UITestWaitHacks.wait(test:self, timeout:1.0)
		let titleText = springboard.staticTexts.matching(identifier: "TodayTitle").firstMatch
		XCTAssert(titleText.exists)
		let expandButton = WidgetUtils.getExpandButton(springboard: springboard)
		let collapseButton = WidgetUtils.getCollapseButton(springboard: springboard)
		if expandButton.exists {
			testExpand(springboard: springboard, expandButton: expandButton)
			testCollapse(springboard: springboard, collapseButton: collapseButton)
		} else {
			testCollapse(springboard: springboard, collapseButton: collapseButton)
			testExpand(springboard: springboard, expandButton: expandButton)
		}
	}
	
	private func testExpand(springboard: XCUIApplication, expandButton: XCUIElement) {
		let definitionsText = springboard.staticTexts.matching(identifier: "TodayDefinitions").firstMatch
		XCTAssert(!definitionsText.exists)
		expandButton.tap()
		XCTAssert(definitionsText.exists)
	}
	private func testCollapse(springboard: XCUIApplication, collapseButton: XCUIElement) {
		let definitionsText = springboard.staticTexts.matching(identifier: "TodayDefinitions").firstMatch
		XCTAssert(definitionsText.exists)
		collapseButton.tap()
		XCTAssert(!definitionsText.exists)
	}
}
