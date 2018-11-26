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

class ThemeTest: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}

	// Don't really know what assertions we can put here to test themes.
	// We'll just select the theme and navigate back in the app, at least
	// to make sure there aren't crashes.
	func testThemes() {
		for _ in 0..<3 {
			UITestNavigation.openSettings(app: app)
			app.switches.matching(identifier: "SwitchDarkTheme").firstMatch.tap()
			app.navigationBars.buttons.firstMatch.tap()
			app.navigationBars.buttons.firstMatch.tap()
		}
	}
}
