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

import Foundation

class Settings {
	private static let KEY_TAB = "tab"
	private static let DEFAULT_TAB = Tab.dictionary
	class func getTab() -> Tab {
		if let tabName = UserDefaults.init().object(forKey: KEY_TAB) as? String {
			if let tab = Tab(rawValue: tabName) {
				return tab
			}
		}
		return DEFAULT_TAB
	}
	
	class func setTab(tab: Tab) {
		let userDefaults = UserDefaults.init()
		userDefaults.setValue(tab.rawValue, forKey: KEY_TAB)
		userDefaults.synchronize()
	}
}
