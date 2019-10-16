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
class SearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteDelegate, SearchResultHeaderDelegate {
	
	@IBOutlet weak var viewResultHeader: SearchResultHeaderView!
	private let speechSynthesizer = AVSpeechSynthesizer()
	
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
		NotificationCenter.default.addObserver(self, selector:#selector(userDataChanged), name:Notification.Name.NSManagedObjectContextDidSave, object:nil)
		viewResultHeader.delegate = self
		updateUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		efficientLayoutEnabled = Settings.getEfficientLayoutEnabled()
	}
	@objc
	func userDataChanged(notification: Notification) {
		if CoreDataNotificationHelper.isNotificationForFavorites(notification: notification) {
			DispatchQueue.main.async{[weak self] in
				self?.updateUI()
			}
		}
	}
	private func updateUI() {
		viewResultHeader.labelWord.text = query.localizedLowercase
		if let nonEmptyQuery = viewResultHeader.labelWord.text, !nonEmptyQuery.isEmpty {
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
			viewResultHeader.buttonFavorite.isSelected = Favorite.isFavorite(context: AppDelegate.persistentUserDbContainer.viewContext, word: query)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	func didClickFavorite(word: String) {
		viewResultHeader.buttonFavorite.isSelected = !viewResultHeader.buttonFavorite.isSelected
		toggleFavorite(query: word)
	}
	func didClickLookup(word: String) {
		if let urlString = "https://www.google.com/search?q=\(word)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url, options:[:])
			}
		}
	}
	
	func didClickPlay(word: String) {
		let utterance = Tts.createUtterance(text: word)
		speechSynthesizer.speak(utterance)
	}

	func didClickShare(sender: UIView) {
		if let shareText = getShareText() {
			let shareController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
			shareController.popoverPresentationController?.sourceView = sender
			present(shareController, animated:true, completion:nil)
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
	open func getShareText() -> String? {
		return nil
	}
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
