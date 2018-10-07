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
class WordCounter {
	// The following will each be considered as one word: good-hearted, don't, variable_name
	private static let NON_SPLITTING_PUNCTUATION = "-'’_"
	
	private static let REGEX_STRIP = "[\(NON_SPLITTING_PUNCTUATION)]"
	private static let REGEX_SPLIT = "[\\w0-9]+"
	
	static func countWords(text: String?) -> Int {
		if text == nil || text!.isEmpty {
			return 0
		}
		let regexStrip = try! NSRegularExpression(pattern: REGEX_STRIP, options: NSRegularExpression.Options.caseInsensitive)
		let range = NSMakeRange(0, text!.utf16.count)
		let strippedText = regexStrip.stringByReplacingMatches(in: text!, options: [], range: range, withTemplate: "")
		
		let regexSplit = try! NSRegularExpression(pattern: REGEX_SPLIT, options: NSRegularExpression.Options.caseInsensitive)
		let matches = regexSplit.matches(in: strippedText, range: NSMakeRange(0, strippedText.utf16.count))

		var tokens = [String]()
		matches.forEach { result in
			for i in 0..<result.numberOfRanges {
				let range = result.range(at: i)
				let token = strippedText[Range(range, in: strippedText)!]
				if !token.isEmpty {
					tokens.append(String(token))
				}
			}
		}
		return tokens.count
	}
	
	static func countCharacters(text:String?) -> Int {
		return text?.utf16.count ?? 0
	}
}
