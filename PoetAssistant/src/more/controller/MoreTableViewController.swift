//
//  MoreTableViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 25/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
protocol MoreDelegate:class {
	func didFinish()
}
class MoreTableViewController: UITableViewController, UIDocumentPickerDelegate {

	weak var document: PoemDocument? = nil
	weak var delegate: MoreDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBOutlet weak var cellSharePoemText: UITableViewCell!
	
	@IBOutlet weak var cellNew: UITableViewCell!
	@IBOutlet weak var cellImport: UITableViewCell!
	@IBOutlet weak var cellSaveAs: UITableViewCell!
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		if cell == cellSharePoemText, let text = document?.text {
			present(UIActivityViewController(activityItems: [text], applicationActivities: nil), animated:true, completion:nil)
		} else if cell == cellNew {
			promptForFilename(okButtonLabelId: "save_as_action_create") { [weak self] filename in
				self?.document?.newDocument(filename: filename)
				self?.delegate?.didFinish()
			}
		} else if cell == cellSaveAs {
			promptForFilename(okButtonLabelId: "save_as_action_rename") { [weak self] filename in
				self?.document?.saveAs(newFilename: filename)
				self?.delegate?.didFinish()
			}
		} else if cell == cellImport {
			let picker = UIDocumentPickerViewController(documentTypes: ["public.plain-text"], in:UIDocumentPickerMode.import)
			present(picker, animated:true, completion:nil)
			picker.delegate = self
		}
	}
	
	func documentPicker(_ controller: UIDocumentPickerViewController,
						didPickDocumentsAt urls: [URL]) {
		if let url = urls.first, controller.documentPickerMode == UIDocumentPickerMode.import {
			document?.importDocument(url: url)
			delegate?.didFinish()
		}
	}
	
	func promptForFilename(okButtonLabelId: String, block: @escaping (String) -> Void) {
		let alert = UIAlertController(
			title: NSLocalizedString("save_as_title", comment: ""),
			message: "",
			preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(
			title: NSLocalizedString(okButtonLabelId, comment: ""),
			style: UIAlertAction.Style.destructive, handler: { action in
				if let filename = alert.textFields?.first?.text {
					block(filename)
				}
		}))
		alert.addTextField(configurationHandler: {textField in
			
		})
		alert.addAction(UIAlertAction(
			title: NSLocalizedString("save_as_action_cancel", comment: ""),
			style: UIAlertAction.Style.cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}
