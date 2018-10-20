//
//  TtsPlayButtonUpdater.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 20/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

class TtsPlayButtonConnector: NSObject, AVSpeechSynthesizerDelegate {
	
	private weak var playButton: UIButton?
	private let speechSynthesizer: AVSpeechSynthesizer
	var textToSpeak: String?

	init(playButton: UIButton) {
		self.speechSynthesizer = AVSpeechSynthesizer()
		self.playButton = playButton
		super.init()
		speechSynthesizer.delegate = self
	}
	
	func didTapPlayButton() {
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking(at: .immediate)
		} else {
			let utterance = Tts.createUtterance(text: textToSpeak ?? "")
			speechSynthesizer.speak(utterance)
		}
	}

	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	
	private func updatePlayButton() {
		if speechSynthesizer.isSpeaking {
			playButton?.setImage(UIImage(imageLiteralResourceName: "ic_stop"), for:.normal)
		} else {
			playButton?.setImage(UIImage(imageLiteralResourceName: "ic_play"), for:.normal)
		}
	}
}
