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
