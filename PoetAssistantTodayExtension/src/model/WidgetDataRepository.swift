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
import PoetAssistantLexiconsFramework

class WidgetDataRepository {
	private static let CACHE_KEY_WORD = "word"
	private static let CACHE_KEY_DEFINITIONS = "definitions"
	
	private init() {
	}
	
	private class func saveToCache(widgetData: WidgetData) {
		let userDefaults = UserDefaults.init()
		userDefaults.set(widgetData.word, forKey: CACHE_KEY_WORD)
		userDefaults.set(widgetData.definitions, forKey: CACHE_KEY_DEFINITIONS)
		userDefaults.synchronize()
	}
	
	class func loadFromCache() -> WidgetData? {
		let userDefaults = UserDefaults.init()
		if let wotd = userDefaults.string(forKey: CACHE_KEY_WORD),
			let definitions = userDefaults.string(forKey: CACHE_KEY_DEFINITIONS) {
			if wotd.count > 0 && definitions.count > 0 {
				return WidgetData(word: wotd, definitions: definitions)
			}
		}
		return nil
	}
	
	class func loadFromDb(completionHandler: @escaping (WidgetData?) -> Void) {
		CoreDataAccess.persistentDictionariesContainer.performBackgroundTask { context in
			let wotd = Wotd.getWordOfTheDay(context: context)
			if let wotdDefinitions = Dictionary.fetch(context: context, queryText: wotd)?.getDefinitionsText() {
				DispatchQueue.main.async {
					let widgetData = WidgetData(word: wotd, definitions: wotdDefinitions)
					saveToCache(widgetData: widgetData)
					completionHandler(widgetData)
				}
			} else {
				DispatchQueue.main.async {
					completionHandler(nil)
				}
			}
		}
	}
}
