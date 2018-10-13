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
	private static let KEY_LEXICON = "lexicon"
	private static let KEY_SEARCH_HISTORY = "search_history"

	private static let DEFAULT_TAB = Tab.composer
	private static let DEFAULT_LEXICON = Lexicon.rhymer

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
	
	class func getLexicon() -> Lexicon {
		if let lexiconName = UserDefaults.init().object(forKey: KEY_LEXICON) as? String {
			if let lexicon = Lexicon(rawValue: lexiconName) {
				return lexicon
			}
		}
		return DEFAULT_LEXICON
	}
	
	class func setLexicon(lexicon: Lexicon) {
		let userDefaults = UserDefaults.init()
		userDefaults.setValue(lexicon.rawValue, forKey: KEY_LEXICON)
		userDefaults.synchronize()
	}
	
	class func isSearchHistoryEnabled() ->Bool {
		let userDefaults = UserDefaults.init()
		return userDefaults.bool(forKey: KEY_SEARCH_HISTORY)
	}
	
	class func setSearchHistoryEnabled(enabled: Bool) {
		let userDefaults = UserDefaults.init()
		userDefaults.setValue(enabled, forKey: KEY_SEARCH_HISTORY)
		userDefaults.synchronize()
		if !enabled {
			Suggestion.clearHistory(completion:nil)
		}
	}
}
