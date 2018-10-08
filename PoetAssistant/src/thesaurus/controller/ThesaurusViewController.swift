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

class ThesaurusViewController: SearchResultsController {
	
	private var fetchedResultsController: ThesaurusFetchedResultsControllerWrapper? = nil
	
	weak var delegate: RTDDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.thesaurus
	}
	
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No synonyms for %@", comment: ""), "\(query)")
	}
	
	override func doQuery(query: String, completion: @escaping () -> Void) {
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			self?.fetchedResultsController = Thesaurus.createFetchResultsController(context: context, queryText: query)
			try? self?.fetchedResultsController?.performFetch()
			// No results? How about trying the stem of the word.
			if (self?.fetchedResultsController?.sections.count ?? 0) == 0 {
				let stemmedWord = PorterStemmer().stemWord(word:query)
				if (stemmedWord != query) {
					DispatchQueue.main.async {
						self?.query = stemmedWord
					}
					return
				}
			}
			DispatchQueue.main.async {
				completion()
			}
		}
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections, sections.count > section {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController?.sections, sections.count > section {
			return NSLocalizedString(sections[section].name, comment: "")
		} else {
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let thesaurusListItem = fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) {
			var thesaurusCell: UITableViewCell?
			switch (thesaurusListItem) {
			case .subtitle (let subtitle):
				thesaurusCell = tableView.dequeueReusableCell(withIdentifier: "ThesaurusSubheading") as? ThesaurusRelationshipViewCell
				bindRelationshipCell(
					cellView: thesaurusCell as! ThesaurusRelationshipViewCell, relationship: subtitle)
			case .word (let word):
				thesaurusCell = tableView.dequeueReusableCell(withIdentifier: "ThesaurusWord") as? ThesaurusTableViewCell
				bindWordCell(cellView: thesaurusCell as! ThesaurusTableViewCell, word: word)
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
	private func bindWordCell(cellView: ThesaurusTableViewCell, word: String) {
		cellView.labelWord.text = word
		cellView.delegate = delegate
	}
}

