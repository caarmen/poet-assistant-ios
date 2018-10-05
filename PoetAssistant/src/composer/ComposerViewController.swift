//
//  ComposerViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController, UITextViewDelegate {
	private var notificationObserver: NSObjectProtocol? = nil

	@IBOutlet weak var text: UITextView! {
		didSet {
			text.delegate = self
		}
	}

	@IBOutlet weak var hint: UILabel!
	@IBAction func onShare(_ sender: Any) {
		present(UIActivityViewController(activityItems: [text.text], applicationActivities: nil), animated:true, completion:nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		text.text = Poem.readDraft().text
		updateTextHint()
		text.becomeFirstResponder()
		addNotificationObserver()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addNotificationObserver()
	}
	
	private func addNotificationObserver() {
		if notificationObserver != nil {
			NotificationCenter.`default`.removeObserver(notificationObserver)
		}
		notificationObserver = NotificationCenter.`default`.addObserver(
			forName: Notification.Name.onquery,
			object:nil,
			queue:OperationQueue.main,
			using: { [weak self] notification in
				self?.dismiss(animated: true, completion: nil)
				if (self?.tabBarController?.selectedViewController == self) {
					(self?.tabBarController as? TabBarController)?.goToTab(tab: Tab.dictionary)
				}
		})
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.`default`.removeObserver(self)
	}
	
	private func updateTextHint() {
		hint.isHidden = !text.text.isEmpty
	}
	
	func textViewDidChange(_ textView: UITextView) {
		updateTextHint()
		Poem(withText: text.text).saveDraft()
	}
	
}
