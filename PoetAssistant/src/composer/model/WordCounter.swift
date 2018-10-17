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
	// For the word count, we'll consider words to be composed only of letters and numbers
	private static let WORD_CHARACTERS = "\\p{L}\\p{N}"
	
	// For the character count, we'll count letters, punctuation, whitespace, and numbers
	private static let COUNTED_CHARACTERS = "\(WORD_CHARACTERS)\\p{P}\\p{Z}\\n"

	// The following will each be considered as one word: good-hearted, don't, variable_name
	private static let REGEX_STRIP_HYPHENS = "[-'’_]"
	
	private static let REGEX_NOT_COUNTED_CHARACTERS = "[^\(COUNTED_CHARACTERS)]+"
	private static let REGEX_WORD_CHARACTERS = "[\(WORD_CHARACTERS)]+"
	
	static func countWords(text: String?) -> Int {
		if text == nil || text!.isEmpty {
			return 0
		}
		let textWithHyphenatedWordsMerged = strip(text: text!, pattern: REGEX_STRIP_HYPHENS, replace:"")
		
		// Remove weird characters like emojis
		let textWithCountedCharacters = strip(text: textWithHyphenatedWordsMerged, pattern: REGEX_NOT_COUNTED_CHARACTERS, replace:"")
		
		let regexSplit = try! NSRegularExpression(pattern: REGEX_WORD_CHARACTERS, options: NSRegularExpression.Options.caseInsensitive)
		let matches = regexSplit.matches(in: textWithCountedCharacters, range: NSMakeRange(0, textWithCountedCharacters.utf16.count))

		var tokens = [String]()
		matches.forEach { result in
			for i in 0..<result.numberOfRanges {
				let range = result.range(at: i)
				if let rangeInText = Range(range, in: textWithCountedCharacters) {
				let token = textWithCountedCharacters[rangeInText]
					if !token.isEmpty {
						tokens.append(String(token))
					}
				}
			}
		}
		return tokens.count
	}
	
	private static func strip(text: String, pattern: String, replace: String) -> String {
		let range = NSMakeRange(0, text.utf16.count)
		let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
		return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: replace)
	}
	
	static func countCharacters(text:String?) -> Int {
		if text == nil {
			return 0
		}
		let textWithoutSymbols = strip(text: text!, pattern: REGEX_NOT_COUNTED_CHARACTERS, replace:"")
		return textWithoutSymbols.utf16.count
	}
}
