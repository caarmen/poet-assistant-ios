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

protocol PoemDocumentDelegate:class {
	func didSaveStart()
	func didSaveComplete()
}
class PoemDocument: UIDocument {
	var text: String = ""
	weak var delegate: PoemDocumentDelegate?
	
	class func loadSavedPoem() -> PoemDocument {
		let poemFilename = Settings.getPoemFilename()
		let url = FileUtils.buildDocumentUrl(filename: poemFilename)
		let doc = PoemDocument(fileURL: url)
		if FileManager().fileExists(atPath: url.path) {
			doc.open(completionHandler: {result in
				doc.delegate?.didSaveComplete()
			})
		} else {
			doc.save(to: url, for: .forCreating)
		}
		return doc
	}

	override func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)? = nil) {
		delegate?.didSaveStart()
		super.save(to:url, for:saveOperation, completionHandler: { [weak self] result in
			self?.delegate?.didSaveComplete()
			completionHandler?(result)
		})
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
	
	func newDocument(completionHandler: (() -> Void)?) {
		saveAs(newText: "",
			   newFilename: Settings.DEFAULT_POEM_FILENAME,
			   completionHandler:completionHandler)
	}
	
	func importDocument(url: URL, completionHandler: (() -> Void)?) {
		do {
			let (oldUrl, oldText) = (fileURL, text)
			try read(from: url)
			let copiedDocUrl = FileUtils.buildDocumentUrl(filename: url.lastPathComponent)
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
		let usableFilename = FileUtils.getUsableFilename(userEnteredFilename: newFilename)
		let url = FileUtils.buildDocumentUrl(filename: usableFilename)
		if url.absoluteString == fileURL.absoluteString && newText == text {
			print ("No changes to document, not performing save as")
			completionHandler?()
		} else {
			text = newText
			save(to: url, for: .forCreating) { [weak self] saved in
				completionHandler?()
				self?.backupOldDocument(oldUrl: oldUrl, oldText: oldText)
			}
		}
	}

	private func backupOldDocument(oldUrl: URL, oldText: String) {
		if (oldUrl.lastPathComponent != fileURL.lastPathComponent) {
			FileUtils.save(url: oldUrl, text: oldText)
		}
	}
}

class ReadError : Error {}
