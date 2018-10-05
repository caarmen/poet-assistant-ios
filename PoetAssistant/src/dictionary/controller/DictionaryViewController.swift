//
//  DictionaryViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import CoreData

class DictionaryViewController: SearchResultsController, UISearchControllerDelegate, UISearchBarDelegate {
	
	private var fetchedResultsController: NSFetchedResultsController<Dictionary>? = nil
	override func viewDidLoad() {
		super.viewDidLoad()
		tab = Tab.dictionary
	}
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No definitions for %@", comment: ""), "\(query)")
	}
	override func doQuery(query: String, completion: @escaping () -> Void) {
		AppDelegate.persistentContainer.performBackgroundTask { [weak self] context in
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
