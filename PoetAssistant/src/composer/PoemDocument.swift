//
//  PoemDocument.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class PoemDocument: UIDocument {
	var text: String = ""
	

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
	class func create(name: String) -> PoemDocument {
		let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name)
		return PoemDocument(fileURL: url)
	}

}

class ReadError : Error {}
