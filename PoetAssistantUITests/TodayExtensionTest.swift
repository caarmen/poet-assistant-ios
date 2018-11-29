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
		// https://stackoverflow.com/questions/36307895/xcuitest-and-today-widget
		let app = XCUIApplication()
		// Open Notification Center
		let bottomPoint = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 2))
		app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).press(forDuration: 0.1, thenDragTo: bottomPoint)
		// Open Today View
		let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
		springboard.scrollViews.firstMatch.swipeRight()
		springboard.buttons["Edit"].tap()
		
		// Add the widget, removing it first if necessary
		if !addWidget(springboard: springboard) {
			removeWidget(springboard: springboard)
			XCTAssert(addWidget(springboard: springboard))
		}
		springboard.buttons["Done"].tap()
		testExpandCollapse(springboard: springboard)
	}
	
	private func addWidget(springboard: XCUIApplication) -> Bool {
		springboard.scrollViews.firstMatch.swipeUp()
		let addWidgetButton = springboard.buttons["Insert Word of the day"]
		if addWidgetButton.exists {
			addWidgetButton.tap()
			return true
		} else {
			return false
		}
	}
	private func removeWidget(springboard: XCUIApplication) {
		springboard.scrollViews.firstMatch.swipeDown()
		let removeWotdButton = springboard.buttons["Delete Word of the day"]
		removeWotdButton.tap()
		springboard.buttons["Remove"].tap()
	}
	private func testExpandCollapse(springboard: XCUIApplication) {
		UITestWaitHacks.wait(test:self, timeout:1.0)
		let titleText = springboard.staticTexts.matching(identifier: "TodayTitle").firstMatch
		XCTAssert(titleText.exists)
		let expandButton = getExpandButton(springboard: springboard)
		let collapseButton = getCollapseButton(springboard: springboard)
		if expandButton.exists {
			testExpand(springboard: springboard, expandButton: expandButton)
			testCollapse(springboard: springboard, collapseButton: collapseButton)
		} else {
			testCollapse(springboard: springboard, collapseButton: collapseButton)
			testExpand(springboard: springboard, expandButton: expandButton)
		}
	}
	
	private func getExpandButton(springboard: XCUIApplication) -> XCUIElement {
		return getWidgetButton(springboard: springboard, buttonLabel: "Show More")
	}
	private func getCollapseButton(springboard: XCUIApplication) -> XCUIElement {
		return getWidgetButton(springboard: springboard, buttonLabel: "Show Less")
	}
	private func getWidgetButton(springboard: XCUIApplication, buttonLabel: String) -> XCUIElement {
		return springboard.otherElements
			.containing(NSPredicate(format: "identifier=%@", "TodayTitle"))
			.containing(NSPredicate(format: "label=%@", buttonLabel))
			.buttons[buttonLabel].firstMatch
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
