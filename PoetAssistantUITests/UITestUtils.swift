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
import Foundation

class UITestUtils {
	class func launchApp() -> XCUIApplication {
		let app = XCUIApplication()
		app.launchArguments = ["UITesting"]
		app.launch()
		return app
	}
	class func clearText(element: XCUIElement) {
		let text = element.value as! String
		for _ in 0..<text.count {
			element.typeText(XCUIKeyboardKey.delete.rawValue)
		}
	}
	
	class func openDictionariesTab(app:XCUIApplication) {
		openTab(app: app, position: 1)
	}
	
	class func openSettingsTab(app:XCUIApplication) {
		openTab(app: app, position: 2)
	}
	
	class func search(test: XCTestCase, app:XCUIApplication, query: String) {
		openDictionariesTab(app: app)
		app.searchFields.firstMatch.typeText("\(query)\n")
		wait(test: test, timeout: 2)
	}
	
	class func waitForPlayButtonToHavePlayImage(test: XCTestCase, playButton: XCUIElement, timeout: TimeInterval) {
		waitForButtonToHaveImage(test: test, button: playButton, imageLabel: "ic play", timeout: timeout)
	}
	class func waitForPlayButtonToHaveStopImage(test: XCTestCase, playButton: XCUIElement, timeout: TimeInterval) {
		waitForButtonToHaveImage(test: test, button: playButton, imageLabel: "ic stop", timeout: timeout)
	}
	class func waitForButtonToHaveImage(test: XCTestCase, button: XCUIElement, imageLabel: String, timeout: TimeInterval) {
		let predicate = NSPredicate(format: "label == '\(imageLabel)'")
		test.expectation(for: predicate, evaluatedWith: button, handler: nil)
		test.waitForExpectations(timeout: timeout, handler: nil)
	}
	
	private class func openTab(app:XCUIApplication, position: Int) {
		let tabs = app.tabBars.firstMatch
		tabs.buttons.element(boundBy: position).tap()
	}
	class func waitFor (test: XCTestCase, timeout: TimeInterval, block: @escaping () -> Bool) {
		let condiationalExpectation  = test.expectation(description: "conditional expectation")
		DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + timeout) {
			if block() {
				condiationalExpectation.fulfill()
			}
		}
		test.wait(for: [condiationalExpectation], timeout: timeout + 0.5)
	}
	
	class func wait(test: XCTestCase, timeout: TimeInterval) {
		waitFor(test:test, timeout:timeout) {
			return true
		}
	}
}
