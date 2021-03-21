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
	private var utterancesToSpeak: [AVSpeechUtterance] = []
	var isHackRecreateSynthesizerNeeded = false

	init(playButton: UIButton) {
		self.speechSynthesizer = AVSpeechSynthesizer()
		self.playButton = playButton
		super.init()
		speechSynthesizer.delegate = self
	}
	
	func didTapPlayButton() {
		if isSpeaking() {
			stopSpeaking()
		} else {
			utterancesToSpeak = Tts.createUtterances(text: textToSpeak ?? "")
			isHackRecreateSynthesizerNeeded = utterancesToSpeak.contains { $0.preUtteranceDelay > TimeInterval(0)}
			playNextUtterance()
		}
		updatePlayButton()
	}

	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		if (!utterancesToSpeak.isEmpty) {
			utterancesToSpeak.removeFirst()
			playNextUtterance()
		}
		updatePlayButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
		updatePlayButton()
	}
	
	private func playNextUtterance() {
		if let nextUtterance = utterancesToSpeak.first {
			speechSynthesizer.speak(nextUtterance)
		}
	}
	private func updatePlayButton() {
		if isSpeaking() {
			playButton?.setImage(UIImage(imageLiteralResourceName: "ic_stop"), for:.normal)
		} else {
			playButton?.setImage(UIImage(imageLiteralResourceName: "ic_play"), for:.normal)
		}
	}
	private func isSpeaking() -> Bool {
		return speechSynthesizer.isSpeaking || !utterancesToSpeak.isEmpty
	}
	private func stopSpeaking() {
		speechSynthesizer.stopSpeaking(at: .immediate)
		utterancesToSpeak = []
		// If we stop the speaking between utterances (during the preUtteranceDelay of one of
		// the utterances), then subsequent calls to speak() don't work: no speech is heard,
		// and our delegate callbacks aren't called.
		// The workaround is to create a new synthesizer after stopping speech
		// https://stackoverflow.com/questions/19672814/an-issue-with-avspeechsynthesizer-any-workarounds/39422205#39422205
		if (isHackRecreateSynthesizerNeeded) {
			speechSynthesizer = AVSpeechSynthesizer()
			speechSynthesizer.delegate = self
		}
	}
}
