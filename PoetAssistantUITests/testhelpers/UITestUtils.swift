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
import Foundation

class UITestUtils {
	class func launchApp() -> XCUIApplication {
		let app = XCUIApplication()
		app.launchArguments = ["UITesting"]
		app.launch()
		return app
	}
	
	class func getRhymerHeader(app: XCUIApplication) -> XCUIElement {
		return getHeader(app:app, headerIdentifier: "RhymerResultHeader")
	}
	class func getThesaurusHeader(app: XCUIApplication) -> XCUIElement {
		return getHeader(app:app, headerIdentifier: "ThesaurusResultHeader")
	}
	class func getDictionaryHeader(app: XCUIApplication) -> XCUIElement {
		return getHeader(app:app, headerIdentifier: "DictionaryResultHeader")
	}
	private class func getHeader(app: XCUIApplication, headerIdentifier: String) -> XCUIElement {
		return app.otherElements.matching(identifier: headerIdentifier).firstMatch
	}

	class func assertVisible(app: XCUIApplication, element: XCUIElement) {
		let window = app.windows.element(boundBy: 0)
		let elementFrame = CGRect(origin: CGPoint(x: Int(element.frame.minX), y: Int(element.frame.minY)),
								  size: CGSize(width: Int(element.frame.width), height: Int(element.frame.height)))
		XCTAssert(window.frame.contains(elementFrame))
	}
	
	class func assertHidden(app: XCUIApplication, element: XCUIElement) {
		let window = app.windows.element(boundBy: 0)
		XCTAssert(!element.exists || !window.frame.contains(element.frame) || !element.isHittable)
	}
}
