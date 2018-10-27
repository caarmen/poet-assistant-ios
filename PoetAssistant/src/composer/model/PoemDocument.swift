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
	
	override func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)? = nil) {
		super.save(to:url, for:saveOperation, completionHandler:completionHandler)
		Settings.setPoemFilename(poemFilename: url.lastPathComponent)
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
	
	func newDocument(filename: String, completionHandler: (() -> Void)?) {
		saveAs(newText: "", newFilename: filename, completionHandler:completionHandler)
	}
	
	func importDocument(url: URL, completionHandler: (() -> Void)?) {
		do {
			let (oldUrl, oldText) = (fileURL, text)
			try read(from: url)
			let copiedDocUrl = PoemDocument.buildUrl(filename: url.lastPathComponent)
			save(to: copiedDocUrl, for: .forCreating) { [weak self] saved in
				completionHandler?()
				self?.backupOldDocument(oldUrl: oldUrl, oldText: oldText)
			}
		} catch let error {
			print ("error importing \(url): \(error)")
		}
	}
	
	func saveAs(newFilename: String, completionHandler: (() -> Void)?) {
		saveAs(newText: text, newFilename: newFilename, completionHandler:completionHandler)
	}
	
	private func saveAs(newText: String, newFilename: String, completionHandler: (() -> Void)?) {
		let (oldUrl, oldText) = (fileURL, text)
		text = newText
		let usableFilename = getUsableFilename(userEnteredFilename: newFilename)
		let url = PoemDocument.buildUrl(filename: usableFilename)
		save(to: url, for: .forCreating) { [weak self] saved in
			completionHandler?()
			self?.backupOldDocument(oldUrl: oldUrl, oldText: oldText)
		}
	}
	
	private func getUsableFilename(userEnteredFilename: String) -> String {
		var filenameWithExtension = userEnteredFilename
		if !filenameWithExtension.hasSuffix(".txt") {
			filenameWithExtension.append(".txt")
		}
		return filenameWithExtension
	}
	
	private func backupOldDocument(oldUrl: URL, oldText: String) {
		if (oldUrl.lastPathComponent != fileURL.lastPathComponent) {
			PoemDocument.save(url: oldUrl, text: oldText)
		}
	}

	class func loadSavedPoem() -> PoemDocument {
		let poemFilename = Settings.getPoemFilename()
		let url = buildUrl(filename: poemFilename)
		let doc = PoemDocument(fileURL: url)
		if FileManager().fileExists(atPath: url.path) {
			doc.open()
		} else {
			doc.save(to: url, for: .forCreating)
		}
		return doc
	}
	
	private class func buildUrl(filename: String) -> URL {
		return try! FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true).appendingPathComponent(filename)
	}
	
	private class func save(url: URL, text: String) {
		if let data = text.data(using: .utf8) {
			do {
				try data.write(to: url)
			} catch let error {
				print ("couldn't save poem to \(url): \(error)")
			}
		}
	}
}

class ReadError : Error {}
