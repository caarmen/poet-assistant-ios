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

class Tts {
	private static let PAUSE_DURATION_S = TimeInterval(0.5)

	class func createUtterance(text: String) -> AVSpeechUtterance {
		return createUtterance(text:text, voiceIdentifier: Settings.getVoiceIdentifier())
	}
	
	class func createUtterance(text: String, voiceIdentifier: String?, preDelay: TimeInterval? = nil) -> AVSpeechUtterance {
		let utterance = AVSpeechUtterance(string: text)
		utterance.rate = Settings.getVoiceSpeed()
		utterance.pitchMultiplier = Settings.getVoicePitch()
		if (preDelay != nil) {
			utterance.preUtteranceDelay = preDelay!
		}
		if voiceIdentifier != nil, let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier!) {
			utterance.voice = voice
		}
		return utterance
	}

	/**
	* Splits a string into multiple utterances for pausing playback.
	*
	* @param text A "..." in the input text indicates a pause, and each subsequent "." after the initial "..." indicates an additional pause.
	*
	* Examples:
	* "To be or not to be... that is the question":  1 pause:  "To be or not to be", (pause), " that is the question"
	* "To be or not to be.... that is the question": 2 pauses: "To be or not to be", (pause), (pause), " that is the question"
	* "To be or not to be. that is the question":    0 pauses: "To be or not to be. that is the question"
	*
	* @return the input split into multiple tokens. An empty-string token in the result indicates a pause.
	*/
	class func createUtterances(text: String) -> [AVSpeechUtterance] {
		let voiceIdentifier = Settings.getVoiceIdentifier()
		var result = [AVSpeechUtterance]()
		// In a sequence of dots, we want to skip the first two.
		var skippedDots = 0
		var pause = TimeInterval(0)
		var prevUtterance: AVSpeechUtterance? = nil
		text.components(separatedBy: ".").forEach { token in
			// The current token is a dot. It may or may not be used to pause.
			if (token.isEmpty) {
				// We've skipped at least two consecutive dots. We can now start adding all dots as
				// pause tokens.
				if (skippedDots >= 1) {
					pause += PAUSE_DURATION_S
					prevUtterance = nil
				}
				// Beginning of a dot sequence. We have to skip the first two dots.
				else {
					skippedDots += 1
				}
			}
			// The current token is actual text to speak.
			else {
				var utterance: AVSpeechUtterance? = nil
				// This is either the first text token of the entire input, or a text token after a pause token.
				// We simply add it to the list.
				if (prevUtterance == nil || prevUtterance!.speechString.isEmpty) {
					utterance = createUtterance(text: token, voiceIdentifier: voiceIdentifier, preDelay: pause)
					result.append(utterance!)
				}
				// The previous token was also actual text.
				// Concatenate the previous token with this one, separating by a single period.
				// This optimization allows us to minimize the number of tokens we'll return, and to rely
				// on the sentence pausing of the TTS engine when less than 3 dots separate two sentences.
				else {
					utterance = createUtterance(text: "\(prevUtterance!.speechString).\(token)", voiceIdentifier: voiceIdentifier)
					utterance!.preUtteranceDelay = prevUtterance!.preUtteranceDelay
					result[result.count - 1] = utterance!
				}
				prevUtterance = utterance
				pause = 0
				skippedDots = 0
			}
		}
		return result
	}
}
