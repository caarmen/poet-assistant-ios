//
//  SearchResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import CoreData

/**
 Displays the interface for entering a search query (with search suggestions).
 */
class SearchController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
	
	private var fetchedResultsController: NSFetchedResultsController<NSDictionary>?
	private var searchController: UISearchController? = nil
	private var queryHandled = false
	
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
			AppDelegate.persistentContainer.performBackgroundTask { [weak self] context in
				self?.fetchedResultsController = Dictionary.createSearchSuggestionsFetchResultsController(context: context, queryText: queryText)
				try? self?.fetchedResultsController?.performFetch()
				DispatchQueue.main.async {[weak self] in
					self?.tableView.reloadData()
				}
			}
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
		handleSelection(selection: selection)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		handleSelection(selection: searchBar.text)
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
		handleSelection(selection: nil)
	}
	
	private func handleSelection(selection: String?) {
		if (queryHandled) {
			return
		}
		queryHandled = true
		var userInfo: [String:String] = [:]
		if (selection != nil) {
			userInfo[Notification.Name.UserInfoKeys.query] = selection!
		}
		NotificationCenter.`default`.post(
			name:Notification.Name.onquery,
			object:self,
			userInfo:userInfo)
	}
}
