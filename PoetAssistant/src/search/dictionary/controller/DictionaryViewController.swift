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

class DictionaryViewController: SearchResultsController, UISearchControllerDelegate, UISearchBarDelegate {

	private var dictionaryQueryResult: DictionaryQueryResult? = nil
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.dictionary
	}
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No definitions for %@", comment: ""), "\(query)")
	}
	
	override func fetch(word: String, completion: @escaping () -> Void) {
		AppDelegate.persistentDictionariesContainer.performBackgroundTask {[weak self] context in
			self?.dictionaryQueryResult = Dictionary.fetch(context: context, queryText: word)
			DispatchQueue.main.async { [weak self] in
				self?.viewResultHeader.labelWord.text = self?.dictionaryQueryResult?.queryText
				completion()
			}
		}
	}

	override func getShareText() -> String? {
		return dictionaryQueryResult?.getShareText()
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return dictionaryQueryResult?.numberOfSections() ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dictionaryQueryResult?.numberOfRowsInSection(section:section) ?? 0
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dictionaryQueryResult?.partOfSpeech(section:section)?.localizedSectionLabel()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let dictionaryEntryCell = tableView.dequeueReusableCell(withIdentifier: "DictionaryEntry") as? DictionaryTableViewCell {
			if let definition = dictionaryQueryResult?.definition(indexPath:indexPath) {
				dictionaryEntryCell.definition.text = definition
			}
			return dictionaryEntryCell
		}
		return UITableViewCell()
	}
}
