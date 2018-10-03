//
//  ComposerViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController, UITextViewDelegate {
	
	@IBOutlet weak var text: UITextView! {
		didSet {
			text.delegate = self
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		text.text = Poem.readDraft().text
		updateTextHint()
		text.becomeFirstResponder()
	}

	@IBOutlet weak var hint: UILabel!
	@IBAction func onShare(_ sender: Any) {
		present(UIActivityViewController(activityItems: [text.text], applicationActivities: nil), animated:true, completion:nil)
	}
	
	private func updateTextHint() {
		hint.isHidden = !text.text.isEmpty
	}
	
	func textViewDidChange(_ textView: UITextView) {
		updateTextHint()
		Poem(withText: text.text).saveDraft()
	}
}
