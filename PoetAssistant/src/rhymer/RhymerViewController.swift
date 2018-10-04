//
//  FirstViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class RhymerViewController: UIViewController, SearchResultProvider {
	@IBOutlet weak var labelQuery: UILabel!
	@IBOutlet weak var tableView: UITableView!
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
	
	private func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No rhymes for %@", comment: ""), "\(query)")
	}
}

