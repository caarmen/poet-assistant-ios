//
//  ComposerViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

class ComposerViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
	private var notificationObserver: NSObjectProtocol? = nil
	private let speechSynthesizer = AVSpeechSynthesizer()
	@IBOutlet weak var playButton: UIButton!
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
		updateButton()
	}
	private func getTextToPlay() -> String {
		if let selectedRange = text.selectedTextRange {
			if let selectedText = text.text(in:selectedRange), !selectedText.isEmpty {
				return selectedText
			}
		}
		return text.text
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		text.text = Poem.readDraft().text
		text.becomeFirstResponder()
		addNotificationObserver()
		updateUi()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addNotificationObserver()
		speechSynthesizer.delegate = self
	}
	
	private func updateUi() {
		hint.isHidden = !text.text.isEmpty
		updateButton()
	}
	
	private func updateButton() {
		playButton.isEnabled = !text.text.isEmpty
		if speechSynthesizer.isSpeaking {
			playButton.setImage(UIImage(imageLiteralResourceName: "ic_stop"), for:.normal)
		} else {
			playButton.setImage(UIImage(imageLiteralResourceName: "ic_play"), for:.normal)
		}
	}
	private func addNotificationObserver() {
		if notificationObserver != nil {
			NotificationCenter.`default`.removeObserver(notificationObserver!)
		}
		notificationObserver = NotificationCenter.`default`.addObserver(
			forName: Notification.Name.onquery,
			object:nil,
			queue:OperationQueue.main,
			using: { [weak self] notification in
				self?.dismiss(animated: true, completion: nil)
				if (self?.tabBarController?.selectedViewController == self) {
					(self?.tabBarController as? TabBarController)?.goToTab(tab: Tab.rhymer)
				}
		})
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.`default`.removeObserver(self)
	}
	
	
	func textViewDidChange(_ textView: UITextView) {
		updateUi()
		Poem(withText: text.text).saveDraft()
	}
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		updateButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		updateButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
		updateButton()
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
		updateButton()
	}
	
}
