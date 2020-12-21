/**
Copyright (c) 2020 Carmen Alvarez

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

import Foundation
import XCTest

class WidgetUtils {
	class func createWidget(test: XCTestCase, springboard: XCUIApplication) {
		// https://stackoverflow.com/questions/36307895/xcuitest-and-today-widget
		XCUIDevice.shared.press(XCUIDevice.Button.home)

		// Open Today View by pressing home and swiping right
		springboard.swipeRight()
		springboard.swipeRight()
		springboard.swipeUp()

		// Edit the list of widgets
		let editButton = springboard.buttons["Edit"]
		UITestWaitHacks.waitForElementToExist(test: test, element: editButton, timeout: 2.0)
		editButton.tap()

		let customizeButton = springboard.buttons["Customize"]
		UITestWaitHacks.waitForElementToExist(test: test, element: customizeButton, timeout: 2.0)
		customizeButton.tap()
		
		// Add the widget, removing it first if necessary
		if !addWidget(springboard: springboard) {
			removeWidgets(test: test, springboard: springboard)
			XCTAssert(addWidget(springboard: springboard))
		}
		let doneButton = springboard.navigationBars.firstMatch.buttons["Done"]
		UITestWaitHacks.waitForElementToExist(test: test, element: doneButton, timeout: 2.0)
		doneButton.firstMatch.tap()
	}

	class func getExpandButton(springboard: XCUIApplication) -> XCUIElement {
		return springboard.buttons["Show More"].firstMatch
	}

	class func getCollapseButton(springboard: XCUIApplication) -> XCUIElement {
		return springboard.buttons["Show Less"].firstMatch
	}

	private class func addWidget(springboard: XCUIApplication) -> Bool {
		springboard.scrollViews.firstMatch.swipeUp()
		let addWidgetButton = springboard.buttons["Insert Word of the day"]
		if addWidgetButton.exists {
			addWidgetButton.tap()
			return true
		} else {
			return false
		}
	}

	private class func removeWidgets(test: XCTestCase, springboard: XCUIApplication) {
		springboard.scrollViews.firstMatch.swipeDown()
		UITestWaitHacks.wait(test: test, timeout: 1.0)
		let deleteButton = springboard.buttons.matching(NSPredicate(format: "label MATCHES %@", "Delete .*"))
		while deleteButton.firstMatch.exists {
			deleteButton.firstMatch.tap()
			springboard.buttons["Remove"].tap()
		}
	}
}
