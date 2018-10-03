//
//  Poem.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import Foundation
class Poem {
	private static let DRAFT_DOCUMENT_NAME = "poem.txt"
	
	private(set) var text: String
	
	init(withText text: String) {
		self.text = text
	}
	
	func saveDraft() {
		save(filename: Poem.DRAFT_DOCUMENT_NAME)
	}
	
	func save(filename: String) {
		if let data = text.data(using: .utf8) {
			if let url = try? FileManager.default.url(
				for: .documentDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true).appendingPathComponent(filename) {
				do {
					try data.write(to: url)
				} catch let error {
					print ("couldn't save poem to \(filename): \(error)")
				}
			}
		}
	}
	
	class func read(filename: String) -> Poem {
		if let url = try? FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true).appendingPathComponent(filename) {
			if let data = try? Data(contentsOf: url) {
				let contents = String(data: data, encoding: .utf8) ?? ""
				return Poem(withText: contents)
			}
		}
		print ("Couldn't read poem from \(filename)")
		return Poem(withText: "")
	}
	
	class func readDraft() -> Poem {
		return read(filename: DRAFT_DOCUMENT_NAME)
	}
}
