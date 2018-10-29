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
class FileUtils {
	private static let NEW_FILE_PREFIX = "poem-"
	private static let FILE_EXTENSION = ".txt"
	private static let VALID_FILENAME_CHARACTERS = "\\p{L}\\p{N}\\. -"
	private init() {
		// Prevent instantiation
	}

	class func deleteAllDocuments() {
		let fileManager = FileManager()
		let documentsFolderUrl = getDocumentFolderUrl()
		let documentsUrls = try! fileManager.contentsOfDirectory(at: documentsFolderUrl, includingPropertiesForKeys: nil, options: [])
		documentsUrls.forEach { url in
			try! fileManager.removeItem(at: url)
		}
	}

	class func getSuggestedNewFilename() -> String {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.dateFormat = "YYYYMMdd-HHmmss"
		let formattedDate = dateFormatter.string(from: now)
		return "\(NEW_FILE_PREFIX)\(formattedDate)\(FILE_EXTENSION)"
	}
	class func buildDocumentUrl(filename: String) -> URL {
		return getDocumentFolderUrl().appendingPathComponent(filename)
	}
	
	private class func getDocumentFolderUrl() -> URL{
		return try! FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true)
	}

	class func save(url: URL, text: String) {
		if let data = text.data(using: .utf8) {
			do {
				try data.write(to: url)
			} catch let error {
				print ("couldn't save poem to \(url): \(error)")
			}
		}
	}
	
	class func getUsableFilename(userEnteredFilename: String) -> String {
		var result = userEnteredFilename
		
		let range = NSMakeRange(0, result.utf16.count)
		let regex = try! NSRegularExpression(pattern: "[^\(VALID_FILENAME_CHARACTERS)]", options: NSRegularExpression.Options.caseInsensitive)
		result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "")
		if result.isEmpty {
			result = "poem"
		}
		if !result.hasSuffix(FILE_EXTENSION) {
			result.append(FILE_EXTENSION)
		}
		return result
	}
}
