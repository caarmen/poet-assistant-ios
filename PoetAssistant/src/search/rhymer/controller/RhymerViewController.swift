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

class RhymerViewController: SearchResultsController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.rhymer
	}
	weak var rtdDelegate: RTDDelegate?
	private var rhymeFetcher: RhymeFetcher? = nil
	
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No rhymes for %@", comment: ""), "\(query)")
	}
	
	override func fetch(word: String, completion: @escaping () -> Void) {
		let favorites = Favorite.fetchFavorites(context: AppDelegate.persistentUserDbContainer.viewContext)
		rhymeFetcher = nil
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { dictionariesContext in
			let fetcher = WordVariants.createRhymeFetcher(context: dictionariesContext, queryText: word, favorites: favorites)
			try? fetcher.performFetch()
			DispatchQueue.main.async { [weak self] in
				self?.rhymeFetcher = fetcher
				completion()
			}
		}
	}
	override func getShareText() -> String? {
		return rhymeFetcher?.toText(query: query)
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return rhymeFetcher?.sectionCount ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rhymeFetcher?.numberOfRowsInSection(section: section) ?? 0
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let rhymeType = rhymeFetcher?.rhymeType(section: section) {
			if let variantNumber = rhymeFetcher?.variant(section: section) {
				return String(format: NSLocalizedString(rhymeType.localizedStringIdForVariant, comment: ""), query, String(variantNumber))
			} else {
				return NSLocalizedString(rhymeType.localizedStringId, comment: "")
			}
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let rhymerWordCell = tableView.dequeueReusableCell(withIdentifier: "RhymerWordCell") as? RTDTableViewCell {
			if let rhymeEntry = rhymeFetcher?.rhyme(at: indexPath) {
				rhymerWordCell.bind(
					word: rhymeEntry.word,
					isFavorite: rhymeEntry.isFavorite,
					showRTD: efficientLayoutEnabled,
					rtdDelegate: rtdDelegate,
					favoriteDelegate: self)
			}
			return rhymerWordCell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !efficientLayoutEnabled, let selectedCell = tableView.cellForRow(at: indexPath) as? RTDTableViewCell {
			RTDAnimator.setRTDVisible(selectedCell: selectedCell, visibleCells: tableView.visibleCells)
		}
	}

}

