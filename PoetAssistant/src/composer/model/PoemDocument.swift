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
// This isn't used yet... Placeholder for when we may add support to save to a file.
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
