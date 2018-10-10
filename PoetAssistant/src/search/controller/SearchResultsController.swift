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
			fetch(word: query, completion: {[weak self] in
				self?.queryResultsFetched(query:nonEmptyQuery)})
		} else {
			emptyText.isHidden = false
			emptyText.text = NSLocalizedString("empty_text_no_query", comment: "")
			labelQuery.isHidden = true
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
	* Fetch the data
	*/
	open func fetch(word: String, completion: @escaping () -> Void) {
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
