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
