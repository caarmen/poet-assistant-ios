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
		let word = dictionaryEntry?[#keyPath(Dictionary.word)] as? String
		cell.textLabel?.text = word
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selection = fetchedResultsController?.object(at: indexPath)[#keyPath(Dictionary.word)] as? String
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
