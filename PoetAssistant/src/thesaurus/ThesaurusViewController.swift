//
//  SecondViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class ThesaurusViewController: UIViewController, SearchResultProvider {

	@IBOutlet weak var labelQuery: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var emptyText: UILabel!
	var query : String? {
		didSet {
			if (isViewLoaded) {
				updateUI()
			}		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if let viewController = segue.destination as? SearchResultsController {
			viewController.didSelect = { [weak self] selection in
				if (selection != nil) {
					self?.query = selection
					(self?.tabBarController as? TabBarController)?.updateQuery(query: selection)
				}
				self?.dismiss(animated: true, completion: nil)
			}
		}
	}
	private func updateUI() {
		labelQuery.text = query?.localizedLowercase
		if let nonEmptyQuery = labelQuery.text, !nonEmptyQuery.isEmpty {
			if (tableView.visibleCells.isEmpty) {
				emptyText.isHidden = false
				labelQuery.isHidden = true
				emptyText.text = String(format: NSLocalizedString("No synonyms for %@", comment: ""), "\(nonEmptyQuery)")
			} else {
				emptyText.isHidden = true
				labelQuery.isHidden = false
				
			}
		} else {
			emptyText.isHidden = false
			emptyText.text = NSLocalizedString("empty_text_no_query", comment: "")
			labelQuery.isHidden = true
		}
	}

}

