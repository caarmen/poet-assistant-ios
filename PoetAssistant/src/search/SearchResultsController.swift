//
//  SearchResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 04/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

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
	var tab: Tab!
	
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
				let notificationTab = notification.userInfo?[Notification.Name.UserInfoKeys.tab] as? String
				if (notificationTab != nil) {
					if Tab(rawValue: notificationTab!) != self?.tab {
						return
					} else {
						self?.tabBarController?.selectedViewController = self
					}
				}
				self?.dismiss(animated: true, completion: nil)
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
