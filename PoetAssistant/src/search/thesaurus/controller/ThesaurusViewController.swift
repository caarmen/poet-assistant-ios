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

class ThesaurusViewController: SearchResultsController {
	
	private static let PART_OF_SPEECH_LABELS:[PartOfSpeech:String] = [.noun: "part_of_speech_n",
																 .adjective: "part_of_speech_a",
																 .adverb: "part_of_speech_r",
																 .verb: "part_of_speech_v"]
	private var thesaurusQueryResult: ThesaurusQueryResult? = nil
	
	weak var delegate: RTDDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.thesaurus
	}
	
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No synonyms for %@", comment: ""), "\(query)")
	}
	
	override func fetch(word: String, completion: @escaping () -> Void) {
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			self?.thesaurusQueryResult = Thesaurus.fetch(context: context, queryText: word)
			DispatchQueue.main.async { [weak self] in
				self?.labelQuery.text = self?.thesaurusQueryResult?.queryText
				completion()
			}
		}
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
			let partOfSpeechStringKey = ThesaurusViewController.PART_OF_SPEECH_LABELS[partOfSpeech] ?? ""
			return NSLocalizedString(partOfSpeechStringKey, comment: "")
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
			case .word (let word):
				thesaurusCell = tableView.dequeueReusableCell(withIdentifier: "ThesaurusWord") as? RTDTableViewCell
				bindWordCell(cellView: thesaurusCell as! RTDTableViewCell, word: word)
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
	private func bindWordCell(cellView: RTDTableViewCell, word: String) {
		cellView.labelWord.text = word
		cellView.rtdDelegate = delegate
		cellView.buttonMore.isHidden = !minimalistLayoutEnabled
		cellView.setRTDVisible(visible: !minimalistLayoutEnabled, animate: false)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if minimalistLayoutEnabled, let selectedCell = tableView.cellForRow(at: indexPath) as? RTDTableViewCell {
			RTDAnimator.setRTDVisible(selectedCell: selectedCell, visibleCells: tableView.visibleCells)
		}
	}
}

