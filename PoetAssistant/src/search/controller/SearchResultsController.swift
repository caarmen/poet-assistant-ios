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
import AVFoundation

/**
Displays the search results for a given query
*/
class SearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteDelegate {
	
	private let speechSynthesizer = AVSpeechSynthesizer()
	@IBOutlet weak var buttonFavorite: UIButton! {
		didSet {
			FavoriteButtonHelper.setupButton(button: buttonFavorite)
		}
	}
	@IBOutlet weak var viewResultHeader: UIView!
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
	internal var efficientLayoutEnabled = false {
		didSet {
			if oldValue != efficientLayoutEnabled {
				tableView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector:#selector(userDataChanged), name:Notification.Name.NSManagedObjectContextDidSave, object:AppDelegate.persistentUserDbContainer.viewContext)
		updateUI()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.backgroundColor = Settings.getTheme().backgroundColor
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		efficientLayoutEnabled = Settings.getEfficientLayoutEnabled()
	}
	@objc
	func userDataChanged(notification: Notification) {
		if CoreDataNotificationHelper.isNotificationForFavorites(notification: notification) {
			updateUI()
		}
	}
	private func updateUI() {
		labelQuery.text = query.localizedLowercase
		if let nonEmptyQuery = labelQuery.text, !nonEmptyQuery.isEmpty {
			fetch(word: query, completion: {[weak self] in
				self?.queryResultsFetched(query:nonEmptyQuery)})
		} else {
			emptyText.isHidden = false
			emptyText.text = NSLocalizedString("empty_text_no_query", comment: "")
			viewResultHeader.isHidden = true
		}
	}
	
	private func queryResultsFetched(query: String) {
		tableView.invalidateIntrinsicContentSize()
		tableView.reloadData()
		if (tableView.visibleCells.isEmpty) {
			emptyText.isHidden = false
			viewResultHeader.isHidden = true
			emptyText.text = getEmptyText(query: query)
		} else {
			emptyText.isHidden = true
			viewResultHeader.isHidden = false
			buttonFavorite.isSelected = Favorite.isFavorite(context: AppDelegate.persistentUserDbContainer.viewContext, word: query)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	@IBAction func didClickFavoriteQueryWord(_ sender: UIButton) {
		buttonFavorite.isSelected = !buttonFavorite.isSelected
		toggleFavorite(query: query)
	}
	@IBAction func didClickLookupQueryWord(_ sender: UIButton) {
		if let urlString = "https://www.google.com/search?q=\(query)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url, options:[:])
			}
		}
	}
	
	@IBAction func didClickPlayQueryWord(_ sender: UIButton) {
		if let queryText = labelQuery.text {
			let utterance = Tts.createUtterance(text: queryText)
			speechSynthesizer.speak(utterance)
		}
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
