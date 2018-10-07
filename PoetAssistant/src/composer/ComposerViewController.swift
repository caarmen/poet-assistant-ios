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

class ComposerViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
	private let speechSynthesizer = AVSpeechSynthesizer()
	private var keyboardHeight:  CGFloat?
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!
	@IBOutlet weak var text: UITextView! {
		didSet {
			text.delegate = self
		}
	}
	
	@IBOutlet weak var hint: UILabel!
	@IBAction func onShare(_ sender: Any) {
		present(UIActivityViewController(activityItems: [text.text], applicationActivities: nil), animated:true, completion:nil)
	}
	
	@IBAction func didTapPlayButton(_ sender: UIButton) {
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking(at: .immediate)
		} else {
			let utterance = AVSpeechUtterance(string: getTextToPlay())
			speechSynthesizer.speak(utterance)
		}
		updatePlayButton()
	}
	private func getTextToPlay() -> String {
		if let selectedRange = text.selectedTextRange {
			if let selectedText = text.text(in:selectedRange) {
				if !selectedText.isEmpty {
					return selectedText
				} else if let rangeFromCursorToEnd = text.textRange(from: selectedRange.start, to: text.endOfDocument) {
					if let textFromCursorToEnd = text.text(in:rangeFromCursorToEnd) {
						if !textFromCursorToEnd.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
							return textFromCursorToEnd
						}
					}
				}
			}
		}
		return text.text
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		text.text = Poem.readDraft().text
		text.becomeFirstResponder()
		updateUi()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		speechSynthesizer.delegate = self
		registerForKeyboardNotifications()
	}
	
	private func updateUi() {
		hint.isHidden = !text.text.isEmpty
		shareButton.isEnabled = !text.text.isEmpty
		updatePlayButton()
	}
	
	private func updatePlayButton() {
		playButton.isEnabled = !text.text.isEmpty
		if speechSynthesizer.isSpeaking {
			playButton.setImage(UIImage(imageLiteralResourceName: "ic_stop"), for:.normal)
		} else {
			playButton.setImage(UIImage(imageLiteralResourceName: "ic_play"), for:.normal)
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
		updateUi()
		Poem(withText: text.text).saveDraft()
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
	
	// Adapt the size of the text view when the keyboard appears. Otherwise the keyboard will remain
	// on top of the text view.
	// https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
	private func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:UIResponder.keyboardDidShowNotification, object:nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name:UIResponder.keyboardWillHideNotification, object:nil)
	}
	
	@objc
	private func keyboardWasShown(notification: Notification) {
		if let size = (notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.size {
			keyboardHeight = size.height
			let contentInsets = UIEdgeInsets(top:0.0, left:0.0, bottom:keyboardHeight!, right:0.0)
			text.contentInset = contentInsets
			text.scrollIndicatorInsets = contentInsets
			scrollToCursor()
		}
	}
	
	@objc
	private func keyboardWillBeHidden(notification: Notification) {
		let contentInsets = UIEdgeInsets.zero
		text.contentInset = contentInsets
		text.scrollIndicatorInsets = contentInsets
	}
	
	private func scrollToCursor() {
		if let selectedRange = text.selectedTextRange {
			let caretRectInTextView = text.caretRect(for: selectedRange.end)
			let caretRectInRootView = view.convert(caretRectInTextView, from: text)
			var visibleRootFrame = view.frame
			visibleRootFrame.size.height -= keyboardHeight ?? 0
			if (!visibleRootFrame.contains(caretRectInRootView)) {
				text.scrollRectToVisible(caretRectInTextView, animated: true)
			}
		}
	}
}
