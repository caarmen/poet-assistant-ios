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
	
	func textViewDidChangeSelection(_ textView: UITextView) {
		var menuItems = UIMenuController.shared.menuItems ?? []
		
		if let _ = getSelectedText() {
			if !menuItems.contains(menuItemRhymer) {
				menuItems.append(menuItemRhymer)
			}
			if !menuItems.contains(menuItemThesaurus) {
				menuItems.append(menuItemThesaurus)
			}
			if !menuItems.contains(menuItemDictionary) {
				menuItems.append(menuItemDictionary)
			}
		} else {
			if let index = menuItems.firstIndex(of: menuItemRhymer) {
				menuItems.remove(at:index)
			}
			if let index = menuItems.firstIndex(of: menuItemThesaurus) {
				menuItems.remove(at:index)
			}
			if let index = menuItems.firstIndex(of: menuItemDictionary) {
				menuItems.remove(at:index)
			}
		}
		UIMenuController.shared.menuItems = menuItems
		UIMenuController.shared.update()
	}
	
	private func getSelectedText() -> String? {
		if let selectedRange = text.selectedTextRange {
			if let selectedText = text.text(in:selectedRange), !selectedText.isEmpty {
				return selectedText
			}
		}
		return nil
	}
	
	@objc func menuItemRhymerSelected() {
		if let selectedText = getSelectedText() {
			rtdDelegate?.searchRhymer(query:selectedText)
		}
	}
	@objc func menuItemThesaurusSelected() {
		if let selectedText = getSelectedText() {
			rtdDelegate?.searchThesaurus(query:selectedText)
		}
	}
	@objc func menuItemDictionarySelected() {
		if let selectedText = getSelectedText() {
			rtdDelegate?.searchDictionary(query:selectedText)
		}
	}
}
