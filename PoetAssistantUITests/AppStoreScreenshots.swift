//
//  AppStoreScreenshots.swift
//  PoetAssistantUITests
//
//  Created by Carmen Alvarez on 28/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

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
		UITestUtils.openSettings(app: app)
		app.switches.matching(identifier: "SwitchDarkTheme").firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		app.navigationBars.buttons.firstMatch.tap()
		takeScreenshots()
	}
	
	func takeScreenshots() {
		UITestUtils.openComposerTab(app: app)
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		textViewPoem.tap()
		textViewPoem.typeText("Roses are red.\nViolets are blue.\nIf you are a poet,\nthis app is for you.")
		attachScreenshot(name: "composer")
		
		let buttonHideKeyboard = app.buttons.matching(identifier: "ComposerButtonHideKeyboard").firstMatch
		buttonHideKeyboard.tap()
		UITestUtils.search(test: self, app:app, query: "chance")
		UITestUtils.moveToRhymer(app: app)
		UITestUtils.starWord(test:self, app:app, word: "askance")
		attachScreenshot(name: "rhymer")
		
		UITestUtils.moveToThesaurus(app: app)
		UITestUtils.starWord(test:self, app:app, word: "possibleness")
		attachScreenshot(name: "thesaurus")
		
		UITestUtils.moveToDictionary(app: app)
		attachScreenshot(name: "dictionary")
		
		starWords(words: "acquiesce", "benight", "deferential", "fractious", "implacable", "obfuscation", "peon")
		UITestUtils.moveToFavorites(app: app)
		attachScreenshot(name: "favorites")
	}
	
	private func starWords(words: String...) {
		UITestUtils.moveToDictionary(app:app)
		let headerFavoriteButton = app.buttons.matching(identifier: "HeaderButtonFavorite")
		for word in words {
			UITestUtils.search(test:self, app:app, query:word)
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
