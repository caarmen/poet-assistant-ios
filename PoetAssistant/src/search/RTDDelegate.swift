//
//  RTDDelegate.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import Foundation

/**
 Handles taps on the "R" "T" "D" icons in a search result list.
*/
protocol RTDDelegate:class {
	func searchRhymer(query: String)
	func searchThesaurus(query: String)
	func searchDictionary(query: String)
}

extension RTDDelegate where Self: Any {
	func searchRhymer(query: String) {
		Search.searchRhymer(query:query, sender:self)
	}
	
	func searchThesaurus(query: String) {
		Search.searchThesaurus(query:query, sender:self)
	}
	
	func searchDictionary(query: String) {
		Search.searchDictionary(query:query, sender:self)
	}
}
