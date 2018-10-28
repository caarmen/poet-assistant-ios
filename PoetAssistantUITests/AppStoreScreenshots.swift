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
	
	func testScreenshots() {
		UITestUtils.openComposerTab(app: app)
		let textViewPoem = app.textViews.matching(identifier: "ComposerTextViewPoem").firstMatch
		textViewPoem.tap()
		textViewPoem.typeText("Roses are red.\nViolets are blue.\nIf you are a poet,\nthis app is for you.")
		attachScreenshot(name: "composer")
		
		let buttonHideKeyboard = app.buttons.matching(identifier: "ComposerButtonHideKeyboard").firstMatch
		buttonHideKeyboard.tap()
		UITestUtils.search(test: self, app:app, query: "chance")
		UITestUtils.moveToRhymer(app: app)
		attachScreenshot(name: "rhymer")
		
		UITestUtils.moveToThesaurus(app: app)
		attachScreenshot(name: "thesaurus")
		
		UITestUtils.moveToDictionary(app: app)
		attachScreenshot(name: "dictionary")
	}
	
	private func attachScreenshot(name: String) {
		let screenshot = XCUIScreen.main.screenshot()
		let attachment = XCTAttachment(screenshot: screenshot)
		attachment.lifetime = .keepAlways
		attachment.name = name
		add(attachment)
	}

}