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

import UIKit
class PoemDocument: UIDocument {
	var text: String = ""
	
	private static let DRAFT_DOCUMENT_NAME = "poem.txt"
	
	class func loadSavedPoem() -> PoemDocument {
		if let url = Settings.getPoemUrl() {
			let doc = PoemDocument(fileURL: url)
			doc.open(completionHandler: nil)
			return doc
		}
		return createDraft()
	}
	
	private class func createDraft() -> PoemDocument {
		let url = try! FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true).appendingPathComponent(DRAFT_DOCUMENT_NAME)
		let doc = PoemDocument(fileURL: url)
		doc.save(to: url, for: .forCreating, completionHandler: nil)
		return doc
	}
	
	override func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)? = nil) {
		super.save(to:url, for:saveOperation, completionHandler:completionHandler)
		Settings.setPoemUrl(url: url)
	}
	
	override func contents(forType typeName: String) throws -> Any {
		if let data = text.data(using: .utf8) {
			return data
		} else {
			throw ReadError()
		}
	}
	
	override func load(fromContents contents: Any, ofType typeName: String?) throws {
		if let data = contents as? Data {
			text = String(data: data, encoding: .utf8) ?? ""
		}
	}
}

class ReadError : Error {}
