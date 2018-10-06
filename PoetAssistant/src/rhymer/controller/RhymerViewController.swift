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

class RhymerViewController: SearchResultsController {
	override func viewDidLoad() {
		super.viewDidLoad()
		lexicon = Lexicon.rhymer
	}
	weak var delegate: RTDDelegate?
	private var fetchedResultsController: RhymerFetchedResultsControllerWrapper? = nil
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No rhymes for %@", comment: ""), "\(query)")
	}
	override func doQuery(query: String, completion: @escaping () -> Void) {
		AppDelegate.persistentContainer.performBackgroundTask { [weak self] context in
			self?.fetchedResultsController = WordVariants.createRhymesFetchResultsController(context: context, queryText: query)
			try? self?.fetchedResultsController?.performFetch()
			DispatchQueue.main.async {
				completion()
			}
		}
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections, sections.count > 0 {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController?.sections, sections.count > 0 {
			let sectionName = sections[section].name
			if sectionName.contains(".") {
				let variantNumber = String(sectionName[..<sectionName.index(sectionName.startIndex, offsetBy: 1)])
				let rhymeType = String(sectionName.suffix(from: sectionName.index(sectionName.startIndex, offsetBy: 2)))
				return String(format: NSLocalizedString("rhyme_variant_match_type_\(rhymeType)", comment: ""), query, variantNumber)
			} else {
				return NSLocalizedString("rhyme_match_type_\(sectionName)", comment: "")
			}
		} else {
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let rhymerWordCell = tableView.dequeueReusableCell(withIdentifier: "RhymerWordCell") as? RhymerTableViewCell {
			if let rhymerWord = fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) {
				rhymerWordCell.labelWord.text = rhymerWord[#keyPath(WordVariants.word)] as? String
				rhymerWordCell.delegate = delegate
			}
			return rhymerWordCell
		}
		return UITableViewCell()
	}
}

