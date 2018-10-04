//
//  SearchResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

	private var fetchedResultsController: NSFetchedResultsController<NSDictionary>?
	private var searchController: UISearchController? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		searchController = UISearchController(searchResultsController: nil)
		searchController?.searchResultsUpdater = self
		searchController?.obscuresBackgroundDuringPresentation = false
		searchController?.hidesNavigationBarDuringPresentation = false
		searchController?.definesPresentationContext = false
		searchController?.delegate = self
		searchController?.searchBar.delegate = self
		tableView.tableHeaderView = searchController?.searchBar
		definesPresentationContext = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		searchController?.isActive = true
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		searchController?.isActive = false
	}
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
		if let queryText = searchController.searchBar.text, !queryText.isEmpty {
			fetchedResultsController = Dictionary.createQueryFetchResultsController(context: AppDelegate.persistentContainer.viewContext, queryText: queryText)
			try? fetchedResultsController?.performFetch()
			tableView.reloadData()
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		let dictionaryEntry = fetchedResultsController?.object(at: indexPath)
		let word = dictionaryEntry?[Dictionary.COLUMN_WORD] as? String
		cell.textLabel?.text = word
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selection = fetchedResultsController?.object(at: indexPath)[Dictionary.COLUMN_WORD] as? String
		searchController?.searchBar.text = selection
		didSelect?(selection)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		didSelect?(searchBar.text)
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
		didSelect?(nil)
	}

	var didSelect: ((String?) -> Void)?
}
