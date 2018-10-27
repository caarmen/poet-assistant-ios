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
import AVFoundation
import FileProvider

class Settings {
	public static let MIN_VOICE_SPEED = AVSpeechUtteranceMinimumSpeechRate
	public static let MAX_VOICE_SPEED = AVSpeechUtteranceMaximumSpeechRate
	public static let MIN_VOICE_PITCH = Float(0.5)
	public static let MAX_VOICE_PITCH = Float(2.0)
	private static let KEY_TAB = "tab"
	private static let KEY_LEXICON = "lexicon"
	private static let KEY_POEM_FILENAME = "poem_filename"
	private static let KEY_SEARCH_HISTORY = "search_history"
	private static let KEY_VOICE_SPEED = "voice_speed"
	private static let KEY_VOICE_PITCH = "voice_pitch"
	private static let KEY_VOICE_IDENTIFIER = "voice_identifier"
	private static let KEY_EFFICIENT_LAYOUT = "efficient_layout"
	
	private static let DEFAULT_POEM_FILENAME = "poem.txt"
	private static let DEFAULT_VOICE_SPEED = AVSpeechUtteranceDefaultSpeechRate
	private static let DEFAULT_VOICE_PITCH = Float(1.0)
	private static let DEFAULT_TAB = Tab.composer
	private static let DEFAULT_LEXICON = Lexicon.rhymer
	private static let DEFAULT_SEARCH_HISTORY_ENABLED = true
	private static let DEFAULT_EFFICIENT_LAYOUT = false
	
	class func registerDefaults() {
		UserDefaults.init().register(defaults:
			[KEY_TAB: DEFAULT_TAB.rawValue,
			 KEY_LEXICON: DEFAULT_LEXICON.rawValue,
			 KEY_POEM_FILENAME: DEFAULT_POEM_FILENAME,
			 KEY_SEARCH_HISTORY: DEFAULT_SEARCH_HISTORY_ENABLED,
			 KEY_VOICE_SPEED: DEFAULT_VOICE_SPEED,
			 KEY_VOICE_PITCH: DEFAULT_VOICE_PITCH,
			 KEY_EFFICIENT_LAYOUT: DEFAULT_EFFICIENT_LAYOUT])
	}
	class func clear() {
		let userDefaults = UserDefaults.init()
		userDefaults.dictionaryRepresentation().keys.forEach { key in
			userDefaults.removeObject(forKey: key)
		}
		userDefaults.synchronize()
	}
	class func getTab() -> Tab {
		if let tabName = UserDefaults.init().object(forKey: KEY_TAB) as? String {
			if let tab = Tab(rawValue: tabName) {
				return tab
			}
		}
		return DEFAULT_TAB
	}
	
	class func setTab(tab: Tab) {
		let userDefaults = UserDefaults.init()
		userDefaults.setValue(tab.rawValue, forKey: KEY_TAB)
		userDefaults.synchronize()
	}
	
	class func getLexicon() -> Lexicon {
		if let lexiconName = UserDefaults.init().object(forKey: KEY_LEXICON) as? String {
			if let lexicon = Lexicon(rawValue: lexiconName) {
				return lexicon
			}
		}
		return DEFAULT_LEXICON
	}

	class func getPoemFilename() -> String {
		return getStringPref(key: KEY_POEM_FILENAME, defaultValue: DEFAULT_POEM_FILENAME)
	}
	class func setPoemFilename(poemFilename: String) {
		setPref(key: KEY_POEM_FILENAME, value: poemFilename)
	}
	class func setLexicon(lexicon: Lexicon) {
		let userDefaults = UserDefaults.init()
		userDefaults.setValue(lexicon.rawValue, forKey: KEY_LEXICON)
		userDefaults.synchronize()
	}
	
	class func isSearchHistoryEnabled() ->Bool {
		return getBoolPref(key: KEY_SEARCH_HISTORY, defaultValue: DEFAULT_SEARCH_HISTORY_ENABLED)
	}
	
	class func setSearchHistoryEnabled(enabled: Bool) {
		setPref(key: KEY_SEARCH_HISTORY, value: enabled)
		if !enabled {
			Suggestion.clearHistory(completion:nil)
		}
	}
	class func getVoiceIdentifier() -> String? {
		return UserDefaults.init().string(forKey: KEY_VOICE_IDENTIFIER)
	}
	
	class func setVoiceIdentifier(identifier: String) {
		setPref(key: KEY_VOICE_IDENTIFIER, value: identifier)
	}
	
	class func getVoiceSpeed() -> Float {
		return getFloatPref(key: KEY_VOICE_SPEED, defaultValue: DEFAULT_VOICE_SPEED)
	}
	
	class func setVoiceSpeed(speed: Float) {
		setPref(key: KEY_VOICE_SPEED, value: speed)
	}
	
	class func getVoicePitch() -> Float {
		return getFloatPref(key: KEY_VOICE_PITCH, defaultValue: DEFAULT_VOICE_PITCH)
	}
	
	class func setVoicePitch(pitch: Float) {
		setPref(key: KEY_VOICE_PITCH, value: pitch)
	}
	
	class func getEfficientLayoutEnabled() -> Bool {
		return getBoolPref(key: KEY_EFFICIENT_LAYOUT, defaultValue: DEFAULT_EFFICIENT_LAYOUT)
	}
	
	class func setEfficientLayoutEnabled(enabled: Bool) {
		setPref(key: KEY_EFFICIENT_LAYOUT, value: enabled)
	}
	
	private class func getStringPref(key: String, defaultValue: String) -> String {
		let userDefaults = UserDefaults.init()
		if userDefaults.string(forKey: key) == nil {
			userDefaults.setValue(defaultValue, forKey: key)
		}
		return userDefaults.string(forKey: key)!
	}
	private class func getBoolPref(key: String, defaultValue: Bool) -> Bool {
		let userDefaults = UserDefaults.init()
		if userDefaults.object(forKey: key) == nil {
			userDefaults.setValue(defaultValue, forKey: key)
		}
		return userDefaults.bool(forKey: key)
	}
	
	private class func getFloatPref(key: String, defaultValue: Float) -> Float {
		let userDefaults = UserDefaults.init()
		if userDefaults.object(forKey: key) == nil {
			userDefaults.setValue(defaultValue, forKey: key)
		}
		return userDefaults.float(forKey: key)
	}
	
	private class func setPref(key: String, value: Any) {
		let userDefaults = UserDefaults.init()
		userDefaults.setValue(value, forKey: key)
		userDefaults.synchronize()
		print ("Saved \(key) = \(value)")
	}
}
