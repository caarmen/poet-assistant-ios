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

/**
 Displays the search results for a given query
 */
class SearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var labelQuery: UILabel!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var tableView: UITableView!{
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	@IBOutlet weak var emptyText: UILabel!
	var query : String? {
		didSet {
			if (isViewLoaded) {
				updateUI()
			}
		}
	}
	var lexicon: Lexicon!
	
	private var notificationObserver: NSObjectProtocol? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addNotificationObserver()
		updateUI()
	}
	
	private func addNotificationObserver() {
		if (notificationObserver != nil) {
			NotificationCenter.`default`.removeObserver(notificationObserver!)
		}
		notificationObserver = NotificationCenter.`default`.addObserver(
			forName: Notification.Name.onquery,
			object:nil,
			queue:OperationQueue.main,
			using: { [weak self] notification in
				// Don't handle it if it's directed at another tab
				let notificationTab = notification.userInfo?[Notification.Name.UserInfoKeys.lexicon] as? String
				if (notificationTab != nil) {
					if Lexicon(rawValue: notificationTab!) != self?.lexicon {
						return
					}
				}
				if let notificationQuery = notification.userInfo?[Notification.Name.UserInfoKeys.query] as? String {
					self?.query = notificationQuery
				}
		})
	}
	
	override func viewWillAppear(_ animated: Bool) {
		addNotificationObserver()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.`default`.removeObserver(self)
	}
	
	private func updateUI() {
		labelQuery.text = query?.localizedLowercase
		if let nonEmptyQuery = labelQuery.text, !nonEmptyQuery.isEmpty {
			doQuery(query: nonEmptyQuery, completion: { [weak self] in
				self?.queryResultsFetched(query: nonEmptyQuery)
			})
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
	
	open func getEmptyText(query: String) -> String {
		return ""
	}
	open func doQuery(query: String, completion: @escaping () -> Void) {
	}
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
