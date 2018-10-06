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
struct Search {
	static func searchRhymer(query: String, sender: Any?) {
		postSearch(query:query, sender:sender, lexicon:.rhymer)
	}
	
	static func searchThesaurus(query: String, sender: Any?) {
		postSearch(query:query, sender:sender, lexicon:.thesaurus)
	}
	
	static func searchDictionary(query: String, sender: Any?) {
		postSearch(query:query, sender:sender, lexicon:.dictionary)
	}
	
	private static func postSearch(query: String, sender: Any?, lexicon: Lexicon) {
		var userInfo: [String:String] = [:]
		userInfo[Notification.Name.UserInfoKeys.query] = query
		userInfo[Notification.Name.UserInfoKeys.lexicon] = lexicon.rawValue
		NotificationCenter.`default`.post(
			name:Notification.Name.onquery,
			object:sender,
			userInfo:userInfo)
	}
}
