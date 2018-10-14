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
		let utterance = AVSpeechUtterance(string: text)
		utterance.rate = Settings.getVoiceSpeed()
		utterance.pitchMultiplier = Settings.getVoicePitch()
		return utterance
	}
}
