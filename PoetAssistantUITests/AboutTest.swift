//
//  AboutTest.swift
//  PoetAssistantUITests
//
//  Created by Carmen Alvarez on 20/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import XCTest

class AboutTest: XCTestCase {
	
	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
	}
	
	override func tearDown() {
	}
	
	func testAbout() {
		UITestUtils.openSettingsTab(app: app)
		app.swipeUp()
		
		let aboutElement = app.tables.cells.matching(identifier: "About").firstMatch
		XCTAssert(aboutElement.exists)
		XCTAssert(aboutElement.isHittable)
		aboutElement.tap()
		["AboutSource", "AboutBugs", "AboutPrivacyPolicy", "AboutLicense", "AboutRhymerLicense",
		 "AboutThesaurusLicense", "AboutDictionaryLicense", "AboutPorterStemmer"].forEach {
			tapAboutListItem(identifier: $0)
		}
	}
	private func tapAboutListItem(identifier: String) {
		let element = app.tables.cells.matching(identifier: identifier).firstMatch
		XCTAssert(element.exists)
		XCTAssert(element.isHittable)
		element.tap()
		app.activate()
	}
}
