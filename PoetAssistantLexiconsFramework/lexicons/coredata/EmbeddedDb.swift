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
class EmbeddedDb {
	static func install() {
		let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		if (paths.count > 0) {
			if let toFolder = paths.first, let fromPath = Bundle(for: EmbeddedDb.self).path(forResource: "dictionaries", ofType: "sqlite") {
				let fromUrl = URL.init(fileURLWithPath: fromPath)
				let toFilePath = "\(toFolder)/dictionaries.sqlite"
				let toFolderUrl = URL.init(fileURLWithPath: toFolder)
				let toFileUrl = URL.init(fileURLWithPath: toFilePath)
				print ("should copy \(fromUrl) to \(toFolderUrl)")
				do {
					let fileManager = FileManager()
					if (fileManager.fileExists(atPath: fromPath)) {
						print ("from file exists")
					} else {
						print ("from file doesn't exist")
					}
					if (fileManager.fileExists(atPath: toFilePath)) {
						print ("file already exists")
						return
					} else if (!fileManager.fileExists(atPath: toFolder)) {
						print ("creating folder")
						try fileManager.createDirectory(atPath: toFolder,
														withIntermediateDirectories: true, attributes: nil)
					}
					print ("copy now")
					try fileManager.copyItem(at: fromUrl, to: toFileUrl)
					print ("copied file")
				} catch {
					print ("couldn't copy file \(error)")
				}
			}
		}
	}
}
