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

class AppStoreScreenshots: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testScreenshotsLightTheme() {
		takeScreenshots()
	}
	
	func testScreenshotsDarkTheme() {
		UITestNavigation.openSettings(app: app)
		app.switches.matching(identifier: "SwitchDarkTheme").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		takeScreenshots()
	}
	
	func takeScreenshots() {
		UITestNavigation.openComposerTab(app: app)
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		textViewPoem.tap()
		textViewPoem.typeText("Roses are red.\nViolets are blue.\nIf you are a poet,\nthis app is for you.")
		attachScreenshot(name: "composer")
		
		let buttonHideKeyboard = app.buttons.matching(identifier: "ComposerButtonHideKeyboard").firstMatch
		buttonHideKeyboard.tap()
		UITestActions.search(test: self, app:app, query: "chance")
		UITestNavigation.moveToRhymer(app: app)
		UITestActions.starWord(test:self, app:app, word: "askance")
		attachScreenshot(name: "rhymer")
		
		UITestNavigation.moveToThesaurus(app: app)
		UITestActions.starWord(test:self, app:app, word: "possibleness")
		attachScreenshot(name: "thesaurus")
		
		UITestNavigation.moveToDictionary(app: app)
		attachScreenshot(name: "dictionary")
		
		starWords(words: "acquiesce", "benight", "deferential", "fractious", "implacable", "obfuscation", "peon")
		UITestNavigation.moveToFavorites(app: app)
		attachScreenshot(name: "favorites")
	}
	
	private func starWords(words: String...) {
		UITestNavigation.moveToDictionary(app:app)
		let headerFavoriteButton = app.buttons.matching(identifier: "HeaderButtonFavorite")
		for word in words {
			UITestActions.search(test:self, app:app, query:word)
			headerFavoriteButton.firstMatch.tap()
		}
	}
	private func attachScreenshot(name: String) {
		let screenshot = XCUIScreen.main.screenshot()
		let attachment = XCTAttachment(screenshot: screenshot)
		attachment.lifetime = .keepAlways
		attachment.name = name
		add(attachment)
	}

}
