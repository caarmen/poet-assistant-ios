//
//  Search.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import Foundation
struct Search {
	static func searchRhymer(query: String, sender: Any?) {
		postSearch(query:query, sender:sender, tab:.rhymer)
	}
	
	static func searchThesaurus(query: String, sender: Any?) {
		postSearch(query:query, sender:sender, tab:.thesaurus)
	}
	
	static func searchDictionary(query: String, sender: Any?) {
		postSearch(query:query, sender:sender, tab:.dictionary)
	}
	
	private static func postSearch(query: String, sender: Any?, tab: Tab) {
		var userInfo: [String:String] = [:]
		userInfo[Notification.Name.UserInfoKeys.query] = query
		userInfo[Notification.Name.UserInfoKeys.tab] = tab.rawValue
		NotificationCenter.`default`.post(
			name:Notification.Name.onquery,
			object:sender,
			userInfo:userInfo)
	}
}
