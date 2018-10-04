//
//  DictionaryViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import CoreData

class DictionaryViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate {
	internal var fetchedResultsController: NSFetchedResultsController<Dictionary>? = nil

	@IBOutlet weak var word: UILabel!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var tableView: UITableView!{
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	private var query : String? {
		didSet {
			updateUI()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if let viewController = segue.destination as? SearchResultsController {
			viewController.didSelect = { [weak self] selection in
				if (selection != nil) {
					self?.query = selection
				}
				self?.dismiss(animated: true, completion: nil)
			}
		}
	}

	private func updateUI() {
		word.text = query?.localizedLowercase
		if let nonEmptyQuery = query, !nonEmptyQuery.isEmpty {
			fetchedResultsController = Dictionary.createFetchResultsController(context: AppDelegate.persistentContainer.viewContext, queryText: nonEmptyQuery)
			try? fetchedResultsController?.performFetch()
			tableView.invalidateIntrinsicContentSize()
			tableView.reloadData()
		}
	}
}
