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
	func didClearSearchHistory()
}
/**
Displays the interface for entering a search query (with search suggestions).
*/
class SearchSuggestionsController: UITableViewController, UISearchResultsUpdating {
	
	private var fetchedResultsController: SuggestionsFetchedResultsControllerWrapper?
	weak var delegate: SearchSuggestionsDelegate?
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections.count ?? 0
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sectionName = fetchedResultsController?.sections[section].name {
			return NSLocalizedString(sectionName, comment: "")
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections, sections.count > 0 {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		loadSuggestions(forQuery: searchController.searchBar.text)
	}
	
	func loadSuggestions(forQuery queryText: String?) {
		fetchedResultsController = Suggestion.createSearchSuggestionsFetchResultsController(queryText: queryText)
		fetchedResultsController?.performFetch { [weak self] in
			self?.reloadData()
		}
	}
	private func reloadData() {
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		if let suggestionListItem = fetchedResultsController?.object(at: indexPath) {
			switch (suggestionListItem) {
			case .clear_history:
				bindSuggestionCell(cell: cell, imageResource: "ic_delete", suggestion: NSLocalizedString("clear_search_history_list_item", comment: ""), bold: true)
			case .history_suggestion(let word):
				bindSuggestionCell(cell: cell, imageResource: "ic_history", suggestion: word, bold: false)
			case .dictionary_suggestion(let word):
				bindSuggestionCell(cell: cell, imageResource: "ic_search", suggestion: word, bold: false)
			}
		}
		return cell
	}
	
	private func bindSuggestionCell(cell: UITableViewCell, imageResource: String, suggestion: String?, bold: Bool) {
		cell.imageView?.image = UIImage(imageLiteralResourceName: imageResource)
		cell.textLabel?.text = suggestion
		cell.textLabel?.bold = bold
	}
	
	private func presentClearSearchHistoryDialog() {
		let alert = UIAlertController(
			title: NSLocalizedString("clear_search_history_dialog_title", comment: ""),
			message: NSLocalizedString("clear_search_history_dialog_message", comment: ""),
			preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(
			title: NSLocalizedString("clear_search_history_action_clear", comment: ""),
			style: UIAlertAction.Style.destructive, handler: { action in
				Suggestion.clearHistory (completion: {
					self.presentClearSearchHistoryCompletedDialog()
					self.delegate?.didClearSearchHistory()
				})
		}))
		alert.addAction(UIAlertAction(
			title: NSLocalizedString("clear_search_history_action_cancel", comment: ""),
			style: UIAlertAction.Style.cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	private func presentClearSearchHistoryCompletedDialog() {
		let alert = UIAlertController(
			title: NSLocalizedString("clear_search_history_deleted", comment: ""),
			message: nil,
			preferredStyle: UIAlertController.Style.alert)
		present(alert, animated: true, completion: nil)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			alert.dismiss(animated: false, completion: nil)
		}
		
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let selection = fetchedResultsController?.object(at: indexPath) {
			switch(selection) {
			case .clear_history:
				presentClearSearchHistoryDialog()
			case .history_suggestion(let word), .dictionary_suggestion(let word):
				delegate?.didSelectSuggestion(suggestion: word)
			}
		}
	}
	
	func clear() {
		fetchedResultsController = nil
		reloadData()
	}
}
