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
import PoetAssistantLexiconsFramework

class ThesaurusViewController: SearchResultsController {

	private var thesaurusQueryResult: ThesaurusQueryResult? = nil
	
	weak var rtdDelegate: RTDDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.thesaurus
	}
	
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No synonyms for %@", comment: ""), "\(query)")
	}
	
	override func fetch(word: String, completion: @escaping () -> Void) {
		let favorites = Favorite.fetchFavorites(context: AppDelegate.persistentUserDbContainer.viewContext)
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			self?.thesaurusQueryResult = Thesaurus.fetch(context: context, queryText: word, favorites: favorites, includeReverseLookup: Settings.getReverseThesaurusEnabled())
			DispatchQueue.main.async { [weak self] in
				self?.viewResultHeader.labelWord.text = self?.thesaurusQueryResult?.queryText
				completion()
			}
		}
	}
	override func getShareText() -> String? {
		return thesaurusQueryResult?.toText()
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return thesaurusQueryResult?.sections.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = thesaurusQueryResult?.sections, sections.count > section {
			return sections[section].entries.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = thesaurusQueryResult?.sections, sections.count > section {
			let partOfSpeech = sections[section].partOfSpeech
			return partOfSpeech.localizedSectionLabel()
		} else {
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let thesaurusListItem = thesaurusQueryResult?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) {
			var thesaurusCell: UITableViewCell?
			switch (thesaurusListItem) {
			case .subtitle (let subtitle):
				thesaurusCell = tableView.dequeueReusableCell(withIdentifier: "ThesaurusSubheading") as? ThesaurusRelationshipViewCell
				bindRelationshipCell(
					cellView: thesaurusCell as! ThesaurusRelationshipViewCell, relationship: subtitle)
			case .wordEntry (let wordEntry):
				thesaurusCell = tableView.dequeueReusableCell(withIdentifier: "ThesaurusWord") as? RTDTableViewCell
				bindWordCell(cellView: thesaurusCell as! RTDTableViewCell, wordEntry: wordEntry)
			}
			if (thesaurusCell != nil) {
				return thesaurusCell!
			}
		}
		return UITableViewCell()
	}
	
	private func bindRelationshipCell(cellView: ThesaurusRelationshipViewCell, relationship: WordRelationship) {
		switch (relationship) {
		case .synonym:
			cellView.labelRelationship.text = NSLocalizedString("thesaurus_synonyms_title", comment: "")
		case .antonym:
			cellView.labelRelationship.text = NSLocalizedString("thesaurus_antonyms_title", comment: "")
		}
	}
	private func bindWordCell(cellView: RTDTableViewCell, wordEntry: ThesaurusWordEntry) {
		cellView.bind(
			word: wordEntry.word,
			isFavorite: wordEntry.isFavorite,
			showRTD: efficientLayoutEnabled,
			rtdDelegate: rtdDelegate,
			favoriteDelegate: self)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !efficientLayoutEnabled, let selectedCell = tableView.cellForRow(at: indexPath) as? RTDTableViewCell {
			RTDAnimator.setRTDVisible(selectedCell: selectedCell, visibleCells: tableView.visibleCells)
		}
	}
}

