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
extension ComposerViewController : PoemDocumentDelegate {
	
	internal func registerForDocumentChanges() {
		NotificationCenter.default.addObserver(self, selector:#selector(documentStateChanged), name:UIDocument.stateChangedNotification, object:document)
		document.delegate = self
	}
	
	internal func updateDocumentText(text: String) {
		if (document.documentState == .normal) {
			document.text = text
			labelSaving.text = NSLocalizedString("document_state_unsaved", comment: "")
			document.updateChangeCount(.done)
		}
	}

	@objc
	func documentStateChanged(notification: Notification) {
		if (document.documentState.contains(.normal)) {
			text.text = document.text
			updateUi()
		}
	}
	
	func didSaveStart() {
		labelSaving.text = NSLocalizedString("document_state_saving", comment: "")
	}
	
	func didSaveComplete() {
		labelSaving.text = NSLocalizedString("document_state_saved", comment: "")
	}
}
