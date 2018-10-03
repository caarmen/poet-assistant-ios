//
//  EmbeddedDb.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import Foundation
class EmbeddedDb {
	static func install() {
		let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		if (paths.count > 0) {
			if let toFolder = paths.first, let fromPath = Bundle.main.path(forResource: "dictionaries", ofType: "sqlite") {
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
