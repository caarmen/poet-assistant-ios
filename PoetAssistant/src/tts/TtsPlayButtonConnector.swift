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
	private var speechSynthesizer: AVSpeechSynthesizer
	var textToSpeak: String?
	var isHackRecreateSynthesizerNeeded = false

	init(playButton: UIButton) {
		self.speechSynthesizer = AVSpeechSynthesizer()
		self.playButton = playButton
		super.init()
		speechSynthesizer.delegate = self
	}
	
	func didTapPlayButton() {
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking(at: .immediate)
			// If we stop the speaking between utterances (during the preUtteranceDelay of one of
			// the utterances), then subsequent calls to speak() don't work: no speech is heard,
			// and our delegate callbacks aren't called.
			// The workaround is to create a new synthesizer after stopping speech
			// https://stackoverflow.com/questions/19672814/an-issue-with-avspeechsynthesizer-any-workarounds/39422205#39422205
			if (isHackRecreateSynthesizerNeeded) {
				speechSynthesizer = AVSpeechSynthesizer()
				speechSynthesizer.delegate = self
				updatePlayButton()
			}
		} else {
			let utterances = Tts.createUtterances(text: textToSpeak ?? "")
			utterances.forEach {utterance in
				speechSynthesizer.speak(utterance)
			}
		}
	}

	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		isHackRecreateSynthesizerNeeded = utterance.preUtteranceDelay > TimeInterval(0)
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
