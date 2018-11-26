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
		UITestNavigation.openSettings(app: app)
		app.switches.matching(identifier: "SwitchMatchAORAO").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		UITestActions.search(test: self, app: app, query: "thorny")
		SearchResultAssertions.assertRhymes(app: app, query: "thorny", expectedFirstRhyme: "barany", expectedSecondRhyme: "brawny")
		UITestActions.search(test: self, app: app, query: "brawny")
		SearchResultAssertions.assertRhymes(app: app, query: "brawny", expectedFirstRhyme: "barany", expectedSecondRhyme: "cornie")
    }
	
	func testAORAODisabled() {
		UITestActions.search(test: self, app: app, query: "thorny")
		SearchResultAssertions.assertRhymes(app: app, query: "thorny", expectedFirstRhyme: "cornie", expectedSecondRhyme: "corny")
		UITestActions.search(test: self, app: app, query: "brawny")
		SearchResultAssertions.assertRhymes(app: app, query: "brawny", expectedFirstRhyme: "barany", expectedSecondRhyme: "scrawny")
	}

	func testAOAAEnabled() {
		UITestNavigation.openSettings(app: app)
		app.switches.matching(identifier: "SwitchMatchAOAA").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		UITestActions.search(test: self, app: app, query: "trauma")
		SearchResultAssertions.assertRhymes(app: app, query: "trauma", expectedFirstRhyme: "bahama", expectedSecondRhyme: "cama")
		UITestActions.search(test: self, app: app, query: "across")
		SearchResultAssertions.assertRhymes(app: app, query: "across", expectedFirstRhyme: "alsace", expectedSecondRhyme: "boss")
	}
	
	func testAOAADisabled() {
		UITestActions.search(test: self, app: app, query: "trauma")
		SearchResultAssertions.assertRhymes(app: app, query: "trauma", expectedFirstRhyme: "abasia", expectedSecondRhyme: "abila")
		UITestActions.search(test: self, app: app, query: "across")
		SearchResultAssertions.assertRhymes(app: app, query: "across", expectedFirstRhyme: "boss", expectedSecondRhyme: "boss'")
	}
	
	func testAOAAAndAORAOEnabled() {
		UITestNavigation.openSettings(app: app)
		app.switches.matching(identifier: "SwitchMatchAOAA").firstMatch.tap()
		app.switches.matching(identifier: "SwitchMatchAORAO").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		UITestActions.search(test: self, app: app, query: "thorny")
		SearchResultAssertions.assertRhymes(app: app, query: "thorny", expectedFirstRhyme: "afghani", expectedSecondRhyme: "albani")
	}
}
