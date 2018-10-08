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

class DictionaryViewController: SearchResultsController, UISearchControllerDelegate, UISearchBarDelegate {
	
	private var fetchedResultsController: NSFetchedResultsController<Dictionary>? = nil
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.dictionary
	}
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No definitions for %@", comment: ""), "\(query)")
	}
	override func doQuery(query: String, completion: @escaping () -> Void) {
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			self?.fetchedResultsController = Dictionary.createDefinitionsFetchResultsController(context: context, queryText: query)
			try? self?.fetchedResultsController?.performFetch()
			// No results? How about trying the stem of the word.
			if (self?.fetchedResultsController?.sections?.count ?? 0) == 0 {
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
		return fetchedResultsController?.sections?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections, sections.count > section {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController?.sections, sections.count > 0 {
			return NSLocalizedString("part_of_speech_\(sections[section].name)", comment: "")
		} else {
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let dictionaryEntryCell = tableView.dequeueReusableCell(withIdentifier: "DictionaryEntry") as? DictionaryTableViewCell {
			if let dictionaryEntry = fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) {
				dictionaryEntryCell.definition.text = dictionaryEntry.definition
			}
			return dictionaryEntryCell
		}
		return UITableViewCell()
	}
}
