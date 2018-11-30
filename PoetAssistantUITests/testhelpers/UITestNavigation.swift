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

class UITestNavigation {
	class func openComposerTab(app:XCUIApplication) {
		openTab(app: app, position: 0)
	}
	class func openDictionariesTab(app:XCUIApplication) {
		openTab(app: app, position: 1)
	}
	class func openMore(app: XCUIApplication) {
		app.navigationBars.buttons.firstMatch.tap()
	}
	class func openSettings(app:XCUIApplication) {
		openMore(app: app)
		app.tables.cells.matching(identifier: "Settings").firstMatch.tap()
	}
	class func moveToRhymer(app:XCUIApplication) {
		moveToLexicon(app:app, position: 0)
	}
	class func moveToThesaurus(app:XCUIApplication) {
		moveToLexicon(app:app, position: 1)
	}
	class func moveToDictionary(app:XCUIApplication) {
		moveToLexicon(app:app, position:2)
	}
	class func moveToFavorites(app:XCUIApplication) {
		moveToLexicon(app:app, position:3)
	}
	private class func moveToLexicon(app:XCUIApplication, position: Int) {
		app.segmentedControls.firstMatch.buttons.element(boundBy: position).tap()
	}
	private class func openTab(app:XCUIApplication, position: Int) {
		let tabs = app.tabBars.firstMatch
		tabs.buttons.element(boundBy: position).tap()
	}
}
