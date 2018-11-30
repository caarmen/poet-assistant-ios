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

class DeepLinkTest: XCTestCase {

    override func setUp() {
		
    }

    override func tearDown() {
    }

    func testDeepLink() {
		let app = UITestUtils.launchApp()

		//https://aross.se/2018/06/17/ios-ui-tests-for-custom-url-scheme.html
		let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
		safari.launch()
		_ = safari.wait(for: .runningForeground, timeout: 30)
		safari.buttons["URL"].tap()
		safari.typeText("poetassistant://query/muffin\n")
		safari.buttons["Open"].tap()
		_ = app.wait(for: .runningForeground, timeout: 5)
		SearchResultAssertions.assertDefinition(app:app, query:"muffin", expectedFirstDefinition: "a sweet quick bread baked in a cup-shaped pan")
		UITestNavigation.moveToRhymer(app: app)
		SearchResultAssertions.assertRhymes(app:app, query: "muffin", expectedFirstRhyme: "mcguffin", expectedSecondRhyme: "toughen")
		UITestNavigation.moveToThesaurus(app: app)
		SearchResultAssertions.assertSynonyms(test: self, app:app, query: "muffin", expectedFirstSynonym: "quick bread", expectedSecondSynonym: "gem")
    }

}
