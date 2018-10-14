//
//  Tts.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 14/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import AVFoundation

class Tts {
	class func createUtterance(text: String) -> AVSpeechUtterance {
		return createUtterance(text:text, voiceIdentifier: Settings.getVoiceIdentifier())
	}
	
	class func createUtterance(text: String, voiceIdentifier: String?) -> AVSpeechUtterance {
		let utterance = AVSpeechUtterance(string: text)
		utterance.rate = Settings.getVoiceSpeed()
		utterance.pitchMultiplier = Settings.getVoicePitch()
		if voiceIdentifier != nil, let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier!) {
			utterance.voice = voice
		}
		return utterance
	}
}
