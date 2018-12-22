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
extension ComposerViewController {

	// Adapt the location of the text view when the keyboard appears. Otherwise the keyboard will remain
	// on top of the text view.
	// https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
	internal func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector:#selector(keyboardWasShown), name:UIResponder.keyboardDidShowNotification, object:nil)
		NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden), name:UIResponder.keyboardWillHideNotification, object:nil)
	}
	@objc func keyboardWasShown(notification: Notification) {
		if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size {
			if let tabBarHeight = tabBarController?.tabBar.frame.height {
				setPlaceholderHeight(height: kbSize.height - tabBarHeight)
			}
		}
	}
	@objc func keyboardWillBeHidden(notification: Notification) {
		setPlaceholderHeight(height: 0.0)
	}
	internal func setPlaceholderHeight(height: CGFloat) {
		DispatchQueue.main.async {[weak self] in
			self?.placeholderHeight.constant = height
			let keyboardIsOpen = height > 0
			self?.hideKeyboardButton.isHidden = !keyboardIsOpen
			self?.constraintKeyboardHidden.priority = keyboardIsOpen ? UILayoutPriority.defaultLow : UILayoutPriority.defaultHigh
			self?.constraintKeyboardVisible.priority = keyboardIsOpen ? UILayoutPriority.defaultHigh : UILayoutPriority.defaultLow
			self?.scrollToCursor(keyboardHeight: height)
		}
	}
	
	private func scrollToCursor(keyboardHeight: CGFloat) {
		if let selectedRange = text.selectedTextRange {
			let caretRectInTextView = text.caretRect(for: selectedRange.end)
			let caretRectInRootView = view.convert(caretRectInTextView, from: text)
			
			let visibleTextFrame = text.frame
			if (!visibleTextFrame.contains(caretRectInRootView)) {
				text.scrollRectToVisible(caretRectInTextView, animated: true)
			}
		}
	}
}
