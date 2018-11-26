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

class FavoritesTest: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}

    func testFavorites() {
		UITestActions.search(test: self, app: app, query: "cheesecake")
		UITestUtils.getRhymerHeader(app: app).buttons.matching(identifier: "HeaderButtonFavorite").firstMatch.tap()
						
		UITestActions.starWord(test:self, app:app, word: "ache")
		UITestNavigation.moveToFavorites(app:app)
		assertExpectedFavorites(favorites: "ache", "cheesecake")
		
		UITestNavigation.moveToRhymer(app:app)
		app.buttons.matching(identifier: "HeaderButtonFavorite").firstMatch.tap()
		UITestNavigation.moveToFavorites(app:app)
		assertExpectedFavorites(favorites: "ache")
		
		app.tables.cells.firstMatch.buttons.matching(identifier: "ButtonFavorite").firstMatch.tap()
		assertExpectedFavorites()
		
		UITestNavigation.moveToDictionary(app: app)
		app.buttons.matching(identifier: "HeaderButtonFavorite").firstMatch.tap()
		UITestNavigation.moveToFavorites(app: app)
		assertExpectedFavorites(favorites: "cheesecake")
		UITestActions.starWord(test:self, app:app, word: "cheesecake")
		assertExpectedFavorites()
		
		UITestNavigation.moveToThesaurus(app: app)
		app.buttons.matching(identifier: "HeaderButtonFavorite").firstMatch.tap()
		UITestNavigation.moveToFavorites(app: app)
		assertExpectedFavorites(favorites: "cheesecake")
		
		app.buttons.matching(identifier: "ButtonClearFavorites").firstMatch.tap()
		UITestActions.acceptDialog(app:app)
		assertExpectedFavorites()
    }
	
	private func assertExpectedFavorites(favorites: String...) {
		XCTAssertEqual(favorites.count, app.tables.cells.count)
		favorites.forEach {
			XCTAssert(app.tables.cells.staticTexts[$0].firstMatch.isHittable)
		}
	}
}
