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

class RhymerSettingsTest: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
    func testAORAOEnabled() {
		UITestUtils.openSettings(app: app)
		app.switches.matching(identifier: "SwitchMatchAORAO").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		UITestUtils.search(test: self, app: app, query: "thorny")
		UITestUtils.checkRhymes(app: app, query: "thorny", expectedFirstRhyme: "barany", expectedSecondRhyme: "brawny")
		UITestUtils.search(test: self, app: app, query: "brawny")
		UITestUtils.checkRhymes(app: app, query: "brawny", expectedFirstRhyme: "barany", expectedSecondRhyme: "cornie")
    }
	
	func testAORAODisabled() {
		UITestUtils.search(test: self, app: app, query: "thorny")
		UITestUtils.checkRhymes(app: app, query: "thorny", expectedFirstRhyme: "cornie", expectedSecondRhyme: "corny")
		UITestUtils.search(test: self, app: app, query: "brawny")
		UITestUtils.checkRhymes(app: app, query: "brawny", expectedFirstRhyme: "barany", expectedSecondRhyme: "scrawny")
	}

	func testAOAAEnabled() {
		UITestUtils.openSettings(app: app)
		app.switches.matching(identifier: "SwitchMatchAOAA").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		UITestUtils.search(test: self, app: app, query: "trauma")
		UITestUtils.checkRhymes(app: app, query: "trauma", expectedFirstRhyme: "bahama", expectedSecondRhyme: "cama")
		UITestUtils.search(test: self, app: app, query: "across")
		UITestUtils.checkRhymes(app: app, query: "across", expectedFirstRhyme: "alsace", expectedSecondRhyme: "boss")
	}
	
	func testAOAADisabled() {
		UITestUtils.search(test: self, app: app, query: "trauma")
		UITestUtils.checkRhymes(app: app, query: "trauma", expectedFirstRhyme: "abasia", expectedSecondRhyme: "abila")
		UITestUtils.search(test: self, app: app, query: "across")
		UITestUtils.checkRhymes(app: app, query: "across", expectedFirstRhyme: "boss", expectedSecondRhyme: "boss'")
	}
	
	func testAOAAAndAORAOEnabled() {
		UITestUtils.openSettings(app: app)
		app.switches.matching(identifier: "SwitchMatchAOAA").firstMatch.tap()
		app.switches.matching(identifier: "SwitchMatchAORAO").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		UITestUtils.search(test: self, app: app, query: "thorny")
		UITestUtils.checkRhymes(app: app, query: "thorny", expectedFirstRhyme: "afghani", expectedSecondRhyme: "albani")
	}
}
