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
protocol MoreDelegate:class {
	func didShare()
	func didImport(url: URL)
	func didCreateNewDocument(newFilename: String)
	func didSaveAs(newFilename: String)
}
class MoreTableViewController: UITableViewController, UIDocumentPickerDelegate {
	weak var delegate: MoreDelegate? = nil
	var emptyPoem = false

	@IBOutlet weak var cellSharePoemText: UITableViewCell!
	
	@IBOutlet weak var cellNew: UITableViewCell!
	@IBOutlet weak var cellImport: UITableViewCell!
	@IBOutlet weak var cellSaveAs: UITableViewCell!
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		if cell == cellSharePoemText {
			delegate?.didShare()
		} else if cell == cellNew {
			promptForFilename(okButtonLabelId: "save_as_action_create") { [weak self] filename in
				self?.delegate?.didCreateNewDocument(newFilename: filename)
			}
		} else if cell == cellSaveAs {
			promptForFilename(okButtonLabelId: "save_as_action_rename") { [weak self] filename in
				self?.delegate?.didSaveAs(newFilename: filename)
			}
		} else if cell == cellImport {
			let picker = UIDocumentPickerViewController(documentTypes: ["public.plain-text"], in:UIDocumentPickerMode.import)
			present(picker, animated:true, completion:nil)
			picker.delegate = self
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if cell == cellSharePoemText && emptyPoem {
			return 0
		} else {
			return super.tableView(tableView, heightForRowAt: indexPath)
		}
	}
	func documentPicker(_ controller: UIDocumentPickerViewController,
						didPickDocumentsAt urls: [URL]) {
		if let url = urls.first, controller.documentPickerMode == UIDocumentPickerMode.import {
			delegate?.didImport(url: url)
		}
	}
	
	func promptForFilename(okButtonLabelId: String, block: @escaping (String) -> Void) {
		let alert = UIAlertController(
			title: NSLocalizedString("save_as_title", comment: ""),
			message: "",
			preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(
			title: NSLocalizedString(okButtonLabelId, comment: ""),
			style: UIAlertAction.Style.default, handler: { action in
				if let filename = alert.textFields?.first?.text {
					block(filename)
				}
		}))
		alert.addTextField(configurationHandler: { textField in
			textField.text = FileUtils.getSuggestedNewFilename()
		})
		alert.addAction(UIAlertAction(
			title: NSLocalizedString("save_as_action_cancel", comment: ""),
			style: UIAlertAction.Style.cancel, handler: nil))
		present(alert, animated: true) {
			if let textField = alert.textFields?.first {
				textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
			}
		}
	}
}
