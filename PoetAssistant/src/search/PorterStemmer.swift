/*
* Copyright (c) 2016 Carmen Alvarez
*
* This file is part of Porter Stemmer.
*
* Porter Stemmer is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Porter Stemmer is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Porter Stemmer.  If not, see <http://www.gnu.org/licenses/>.
*/
import Foundation

/**
* This is a port of https://github.com/caarmen/porter-stemmer/blob/master/library/src/main/java/ca/rmen/porterstemmer/PorterStemmer.java
* This is a simple implementation of the Porter stemming algorithm, defined here:
* <a href="http://tartarus.org/martin/PorterStemmer/def.txt">http://tartarus.org/martin/PorterStemmer/def.txt</a>
* <p>
* This implementation has not been tuned for high performance on large amounts of text. It is
* a simple (naive perhaps) implementation of the rules.
*/
class PorterStemmer {
	static let ZERO_CHAR = Character(UnicodeScalar(0))
	/**
	* @param word the word to stem
	* @return the stem of the word, in lowercase.
	*/
	func stemWord(word: String) -> String {
		var stem = word.lowercased(with: Locale.current)
		if (stem.count < 3) {
			return stem
		}
		stem = stemStep1a(stem)
		stem = stemStep1b(stem)
		stem = stemStep1c(stem)
		stem = stemStep2(stem)
		stem = stemStep3(stem)
		stem = stemStep4(stem)
		stem = stemStep5a(stem)
		stem = stemStep5b(stem)
		return stem
	}
	
	internal func stemStep1a(_ input: String) -> String {
		// SSES -> SS
		if (input.hasSuffix("sses")) {
			return input.substring(0, input.count - 2)
		}
		// IES  -> I
		if (input.hasSuffix("ies")) {
			return input.substring(0, input.count - 2)
		}
		// SS   -> SS
		if (input.hasSuffix("ss")) {
			return input
		}
		// S    ->
		if (input.hasSuffix("s")) {
			return input.substring(0, input.count - 1)
		} else {
			return input
		}
	}
	
	internal func stemStep1b(_ input: String) -> String {
		// (m>0) EED -> EE
		if (input.hasSuffix("eed")) {
			let stem = input.substring(0, input.count - 1)
			let letterTypes = getLetterTypes(stem)
			let m = getM(letterTypes)
			if (m > 0) {
				return stem
			} else {
				return input
			}
		}
		// (*v*) ED  ->
		if (input.hasSuffix("ed")) {
			let stem = input.substring(0, input.count - 2)
			let letterTypes = getLetterTypes(stem)
			if (letterTypes.contains("v")) {
				return step1b2(stem)
			} else {
				return input
			}
		}
		// (*v*) ING ->
		if (input.hasSuffix("ing")) {
			let stem = input.substring(0, input.count - 3)
			let letterTypes = getLetterTypes(stem)
			if (letterTypes.contains("v")) {
				return step1b2(stem)
			} else {
				return input
			}
		}
		return input
	}
	
	private func step1b2(_ input: String)-> String {
		// AT -> ATE
		if (input.hasSuffix("at")) {
			return input + "e"
		} else if (input.hasSuffix("bl")) {
			return input + "e"
		} else if (input.hasSuffix("iz")) {
			return input + "e"
		} else {
			// (*d and not (*L or *S or *Z))
			// -> single letter
			let lastDoubleConsonant = getLastDoubleConsonant(input)
			if (String(lastDoubleConsonant) != "\0" &&
				lastDoubleConsonant != "l"
				&& lastDoubleConsonant != "s"
				&& lastDoubleConsonant != "z") {
				return input.substring(0, input.count - 1)
			} else {
				let letterTypes = getLetterTypes(input)
				let m = getM(letterTypes)
				if (m == 1 && isStarO(input)) {
					return input + "e"
				}
				
			}// (m=1 and *o) -> E
		}// IZ -> IZE
		// BL -> BLE
		return input
	}
	
	internal func stemStep1c(_ input: String) -> String {
		if (input.hasSuffix("y")) {
			let stem = input.substring(0, input.count - 1)
			let letterTypes = getLetterTypes(stem)
			if (letterTypes.contains("v")) {
				return stem + "i"
			}
		}
		return input
	}
	
	internal func stemStep2(_ input: String) -> String {
		let s1 = ["ational", "tional", "enci", "anci", "izer", "bli", // the published algorithm specifies abli instead of bli.
			"alli", "entli", "eli", "ousli", "ization", "ation", "ator", "alism", "iveness", "fulness", "ousness", "aliti", "iviti", "biliti", "logi"]// the published algorithm doesn"t contain this
		let s2 = ["ate", "tion", "ence", "ance", "ize", "ble", // the published algorithm specifies able instead of ble
			"al", "ent", "e", "ous", "ize", "ate", "ate", "al", "ive", "ful", "ous", "al", "ive", "ble", "log"] // the published algorithm doesn"t contain this

		// (m>0) ATIONAL ->  ATE
		// (m>0) TIONAL  ->  TION
		for i in s1.indices {
			if (input.hasSuffix(s1[i])) {
				let stem = input.substring(0, input.count - s1[i].count)
				let letterTypes = getLetterTypes(stem)
				let m = getM(letterTypes)
				if (m > 0) {
					return stem + s2[i]
				} else {
					return input
				}
			}
		}
		return input
	}
	
	internal func stemStep3(_ input: String)-> String {
		let s1 = ["icate", "ative", "alize", "iciti", "ical", "ful", "ness"]
		let s2 = ["ic", "", "al", "ic", "ic", "", ""]
		// (m>0) ICATE ->  IC
		// (m>0) ATIVE ->
		for i in s1.indices {
			if (input.hasSuffix(s1[i])) {
				let stem = input.substring(0, input.count - s1[i].count)
				let letterTypes = getLetterTypes(stem)
				let m = getM(letterTypes)
				if (m > 0) {
					return stem + s2[i]
				} else {
					return input
				}
			}
		}
		return input
		
	}
	
	internal func stemStep4(_ input: String)-> String {
		let suffixes = ["al", "ance", "ence", "er", "ic", "able", "ible", "ant", "ement", "ment", "ent", "ion", "ou", "ism", "ate", "iti", "ous", "ive", "ize"]
		// (m>1) AL    ->
		// (m>1) ANCE  ->
		for suffix in suffixes {
			if (input.hasSuffix(suffix)) {
				let stem = input.substring(0, input.count - suffix.count)
				let letterTypes = getLetterTypes(stem)
				let m = getM(letterTypes)
				if (m > 1) {
					if (suffix == "ion") {
						if (stem[stem.count - 1] == "s" || stem[stem.count - 1] == "t") {
							return stem
						}
					} else {
						return stem
					}
				}
				return input
			}
		}
		return input
	}
	
	internal func stemStep5a(_ input: String)-> String {
		if (input.hasSuffix("e")) {
			let stem = input.substring(0, input.count - 1)
			let letterTypes = getLetterTypes(stem)
			let m = getM(letterTypes)
			// (m>1) E     ->
			if (m > 1) {
				return stem
			}
			// (m=1 and not *o) E ->
			if (m == 1 && !isStarO(stem)) {
				return stem
			}
		}
		return input
	}
	
	internal func stemStep5b(_ input: String)-> String {
		// (m > 1 and *d and *L) -> single letter
		let letterTypes = getLetterTypes(input)
		let m = getM(letterTypes)
		if (m > 1 && input.hasSuffix("ll")) {
			return input.substring(0, input.count - 1)
		} else {
			return input
		}
	}
	
	private func getLastDoubleConsonant(_ input: String)-> Character {
		if (input.count < 2) {
			return Character(UnicodeScalar(0))
		}
		let lastLetter = input[input.count - 1]
		let penultimateLetter = input[input.count - 2]
		if (lastLetter == penultimateLetter && getLetterType(PorterStemmer.ZERO_CHAR, lastLetter) == "c") {
			return lastLetter
		} else {
			return Character(UnicodeScalar(0))
		}
	}
	
	// *o  - the stem ends cvc, where the second c is not W, X or Y (e.g.
	//                                                              -WIL, -HOP)
	private func isStarO(_ input: String)-> Bool {
		if (input.count < 3) {
			return false
		}
		
		let lastLetter = input[input.count - 1]
		if (lastLetter == "w" || lastLetter == "x" || lastLetter == "y") {
			return false
		}
		
		let secondToLastLetter = input[input.count - 2]
		let thirdToLastLetter = input[input.count - 3]
		let fourthToLastLetter = (input.count == 3) ? PorterStemmer.ZERO_CHAR : input[input.count - 4]
		return (getLetterType(secondToLastLetter, lastLetter) == "c"
			&& getLetterType(thirdToLastLetter, secondToLastLetter) == "v"
			&& getLetterType(fourthToLastLetter, thirdToLastLetter) == "c")
	}
	
	internal func getLetterTypes(_ input: String)-> String {
		var letterTypes = ""
		for i in 0..<input.count {
			let letter = input[i]
			let previousLetter = i == 0 ? PorterStemmer.ZERO_CHAR : input[i - 1]
			let letterType = getLetterType(previousLetter, letter)
			if (letterTypes.count == 0 || letterTypes[letterTypes.count - 1] != letterType) {
				letterTypes.append(letterType)
			}
		}
		return letterTypes
	}
	
	internal func getM(_ letterTypes: String)-> Int {
		if (letterTypes.count < 2) {
			return 0
		}
		if (letterTypes[0] == "c") {
			return (letterTypes.count - 1) / 2
		} else {
			return letterTypes.count / 2
		}
	}
	
	private func getLetterType(_ previousLetter: Character, _ letter: Character)-> Character {
		switch (letter) {
		case "a", "e", "i", "o", "u":
			return "v"
		case "y":
			if Int(String(previousLetter)) == 0 || getLetterType(PorterStemmer.ZERO_CHAR, previousLetter) == "v" {
				return "c"
			} else {
				return "v"
			}
		default: return "c"
		}
	}
}

extension String {
	subscript (i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}
	func substring(_ from: Int, _ length: Int) -> String {
		let start = self.index(self.startIndex, offsetBy: from)
		let end = self.index(start, offsetBy: length)
		return String(self[start..<end])
	}
}
