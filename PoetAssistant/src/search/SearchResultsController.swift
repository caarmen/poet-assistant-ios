//
//  SearchResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsController: UITableViewController, UISearchResultsUpdating {

	private var fetchedResultsController: NSFetchedResultsController<Dictionary>?
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections, sections.count > 0 {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		if let queryText = searchController.searchBar.text {
			fetchedResultsController = Dictionary.createFetchResultsController(context: AppDelegate.persistentContainer.viewContext, queryText: queryText, sortColumn: Dictionary.COLUMN_WORD, ascendingSort: true)
			try? fetchedResultsController?.performFetch()
			tableView.reloadData()
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		let dictionaryEntry = fetchedResultsController?.object(at: indexPath)
		cell.textLabel?.text = dictionaryEntry?.word
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selection = fetchedResultsController?.object(at: indexPath).word
		didSelect?(selection)
	}
	
	var didSelect: ((String?) -> Void)?
}
