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
extension ComposerViewController : MoreDelegate {
	func didShare() {
		didFinish()
		let shareController = UIActivityViewController(activityItems: [text.text], applicationActivities: nil)
		shareController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(shareController, animated:true, completion:nil)
	}
	
	func didImport(url: URL) {
		didFinish()
		document.importDocument(url: url) { self.updateUi()}
	}
	
	func didCreateNewDocument(newFilename: String) {
		didFinish()
		document.newDocument(filename: newFilename) {self.updateUi()}
	}
	
	func didSaveAs(newFilename: String) {
		didFinish()
		document.saveAs(newFilename: newFilename) {self.updateUi()}
	}
	
	private func didFinish() {
		navigationController?.popViewController(animated: true)
	}
}