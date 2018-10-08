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
Displays the search results for a given query
*/
class SearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var labelQuery: UILabel!
	@IBOutlet weak var tableView: UITableView!{
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	@IBOutlet weak var emptyText: UILabel!
	var query : String = "" {
		didSet {
			if (isViewLoaded) {
				updateUI()
			}
		}
	}
	var lexicon: Lexicon!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	
	private func updateUI() {
		labelQuery.text = query.localizedLowercase
		if let nonEmptyQuery = labelQuery.text, !nonEmptyQuery.isEmpty {
			executeQuery(query: nonEmptyQuery)
		} else {
			emptyText.isHidden = false
			emptyText.text = NSLocalizedString("empty_text_no_query", comment: "")
			labelQuery.isHidden = true
		}
	}
	
	private func executeQuery(query: String) {
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			// No results? How about trying the stem of the word.
			// This should probably (maybe?) be in the model, but the details can't be completely hidden
			// from the view controller either... we need to know what was the actual query
			// term used in the end, the original
			// or the stem, to display something meaningful to the user:
			// no results => show "no results for 'original term'"
			// results => show the results for the actual term used.
			if !(self?.backgroundFetch(context:context, word:query) ?? false) {
				if let fallbackQuery = self?.getFallbackQuery(query: query), fallbackQuery != query {
					if (self?.backgroundFetch(context:context, word:fallbackQuery) ?? false) {
						DispatchQueue.main.async{self?.labelQuery.text = fallbackQuery}
					}
				}
			}
			DispatchQueue.main.async{self?.queryResultsFetched(query: query)}
		}
	}
	
	private func queryResultsFetched(query: String) {
		tableView.invalidateIntrinsicContentSize()
		tableView.reloadData()
		if (tableView.visibleCells.isEmpty) {
			emptyText.isHidden = false
			labelQuery.isHidden = true
			emptyText.text = getEmptyText(query: query)
		} else {
			emptyText.isHidden = true
			labelQuery.isHidden = false
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	//--------------------------------------------
	// Methods to be implemented by the subclasses
	//--------------------------------------------

	/**
	* Fetch the data and return true if some data was fetched.
	*/
	open func backgroundFetch(context: NSManagedObjectContext, word: String) -> Bool {
		return false
	}

	/**
	* return an optional string to query in case we find no results for the original query
	*/
	open func getFallbackQuery(query: String) -> String? {
		return nil
	}

	open func getEmptyText(query: String) -> String {
		return ""
	}

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
