//
//  SearchResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 04/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addNotificationObserver()
		updateUI()
	}
	
	private func addNotificationObserver() {
		NotificationCenter.`default`.removeObserver(self)
		NotificationCenter.`default`.addObserver(
			forName: Notification.Name.onquery,
			object:nil,
			queue:OperationQueue.main,
			using: { [weak self] notification in
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
			doQuery(query: nonEmptyQuery)
			tableView.invalidateIntrinsicContentSize()
			tableView.reloadData()
			if (tableView.visibleCells.isEmpty) {
				emptyText.isHidden = false
				labelQuery.isHidden = true
				emptyText.text = getEmptyText(query: nonEmptyQuery)
			} else {
				emptyText.isHidden = true
				labelQuery.isHidden = false
			}
		} else {
			emptyText.isHidden = false
			emptyText.text = NSLocalizedString("empty_text_no_query", comment: "")
			labelQuery.isHidden = true
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	open func getEmptyText(query: String) -> String {
		return ""
	}
	open func doQuery(query: String) {
	}
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
