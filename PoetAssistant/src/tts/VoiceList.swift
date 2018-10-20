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

import AVFoundation

extension AVSpeechSynthesisVoice {
	var languageName: String {
		return VoiceList.getLanguageName(languageCode: language)
	}
}

class VoicesForLanguage {
	let displayLanguage: String
	let voices: [AVSpeechSynthesisVoice]
	init(displayLanguage: String, voices: [AVSpeechSynthesisVoice]) {
		self.displayLanguage = displayLanguage
		self.voices = voices
	}
}
class VoiceList {
	
	class func getVoiceList() -> [VoicesForLanguage] {
		let voices = AVSpeechSynthesisVoice.speechVoices()
		let voicesGroupedByLanguageName = Swift.Dictionary(grouping: voices, by: {$0.languageName})
		let sortedLanguageNames = voicesGroupedByLanguageName.keys.sorted { (languageName1, languageName2) in
			return compareLanguageNames(languageName1: languageName1, languageName2: languageName2) < 0
		}
		var result = [VoicesForLanguage]()
		sortedLanguageNames.forEach { languageName in
			if let sortedVoices = voicesGroupedByLanguageName[languageName]?.sorted(by: { (voice1, voice2) in
				return voice1.name.compare(voice2.name).rawValue < 0
			}) {
				result.append(VoicesForLanguage(displayLanguage: languageName, voices: sortedVoices))
			}
		}
		return result
	}
	
	private class func compareLanguageNames(languageName1: String, languageName2: String) -> Int {
		if languageName1 == languageName2 {
			return 0
		}
		let currentLanguage = getLanguageName(languageCode: Locale.autoupdatingCurrent.languageCode ?? "en")
		if languageName1 == currentLanguage {
			return -1
		}
		if languageName2 == currentLanguage {
			return 1
		}
		return languageName1.compare(languageName2).rawValue
	}
	
	internal class func getLanguageName(languageCode: String) -> String {
		let nsLocale = NSLocale.autoupdatingCurrent
		return nsLocale.localizedString(forLanguageCode: languageCode) ?? languageCode
	}
}
