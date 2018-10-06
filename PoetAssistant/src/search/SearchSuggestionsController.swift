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

protocol SearchSuggestionsDelegate:class {
	func didSelectSuggestion(suggestion: String)
}
/**
 Displays the interface for entering a search query (with search suggestions).
 */
class SearchSuggestionsController: UITableViewController, UISearchResultsUpdating {
	
	private var fetchedResultsController: NSFetchedResultsController<NSDictionary>?
	weak var delegate: SearchSuggestionsDelegate?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		resizeTableView()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections?.count ?? 0
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
			if queryText.isEmpty {
				fetchedResultsController = nil
				reloadData()
			} else {
				AppDelegate.persistentContainer.performBackgroundTask { [weak self] context in
					self?.fetchedResultsController = Dictionary.createSearchSuggestionsFetchResultsController(context: context, queryText: queryText)
					try? self?.fetchedResultsController?.performFetch()
					DispatchQueue.main.async {[weak self] in
						self?.reloadData()
					}
				}
			}
		}
	}
	private func reloadData() {
		tableView.reloadData()
		resizeTableView()
	}
	private func resizeTableView() {
		// https://stackoverflow.com/questions/46928333/uitableview-doesnt-update-sizetofit-in-ios-10-but-working-in-ios-11
		var tableFrame = tableView.frame
		if let container = view.superview {
			tableFrame.size.height = min(tableView.contentSize.height, container.frame.height)
			tableView.frame = tableFrame
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
		if let selection = fetchedResultsController?.object(at: indexPath)[#keyPath(Dictionary.word)] as? String {
			delegate?.didSelectSuggestion(suggestion: selection)
		}
	}
	

	func clear() {
		fetchedResultsController = nil
		reloadData()
	}
}
