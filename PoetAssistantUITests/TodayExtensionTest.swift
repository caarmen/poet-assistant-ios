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
		XCUIDevice.shared.press(XCUIDevice.Button.home)

		// Open Today View by pressing home and swiping right
		let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
		springboard.swipeRight()
		springboard.swipeRight()

		// Edit the list of widgets
		let editButton = springboard.buttons["Edit"]
		UITestWaitHacks.waitForElementToExist(test: self, element: editButton, timeout: 2.0)
		editButton.tap()

		let customizeButton = springboard.buttons["Customize"]
		UITestWaitHacks.waitForElementToExist(test: self, element: customizeButton, timeout: 2.0)
		customizeButton.tap()
		
		// Add the widget, removing it first if necessary
		if !addWidget(springboard: springboard) {
			removeWidgets(springboard: springboard)
			XCTAssert(addWidget(springboard: springboard))
		}
		let doneButton = springboard.navigationBars.firstMatch.buttons["Done"]
		UITestWaitHacks.waitForElementToExist(test: self, element: doneButton, timeout: 2.0)
		doneButton.firstMatch.tap()
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
	private func removeWidgets(springboard: XCUIApplication) {
		springboard.scrollViews.firstMatch.swipeDown()
		UITestWaitHacks.wait(test: self, timeout: 1.0)
		let deleteButton = springboard.buttons.matching(NSPredicate(format: "label MATCHES %@", "Delete .*"))
		while deleteButton.firstMatch.exists {
			deleteButton.firstMatch.tap()
			springboard.buttons["Remove"].tap()
		}
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
		return springboard.buttons["Show More"].firstMatch
	}
	private func getCollapseButton(springboard: XCUIApplication) -> XCUIElement {
		return springboard.buttons["Show Less"].firstMatch
	}
	
	private func testExpand(springboard: XCUIApplication, expandButton: XCUIElement) {
		let definitionsText = springboard.staticTexts.matching(identifier: "TodayDefinitions").firstMatch
		XCTAssert(!definitionsText.exists)
		expandButton.tap()
		XCTAssert(definitionsText.exists)
		UITestUtils.attachScreenshot(test: self, name: "widget")
	}
	private func testCollapse(springboard: XCUIApplication, collapseButton: XCUIElement) {
		let definitionsText = springboard.staticTexts.matching(identifier: "TodayDefinitions").firstMatch
		XCTAssert(definitionsText.exists)
		collapseButton.tap()
		XCTAssert(!definitionsText.exists)
	}
}
