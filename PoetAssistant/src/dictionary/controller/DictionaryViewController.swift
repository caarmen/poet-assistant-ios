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
	
	internal var fetchedResultsController: NSFetchedResultsController<Dictionary>? = nil

	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No definitions for %@", comment: ""), "\(query)")
	}
	override func doQuery(query: String) {
		fetchedResultsController = Dictionary.createFetchResultsController(context: AppDelegate.persistentContainer.viewContext, queryText: query)
		try? fetchedResultsController?.performFetch()
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections?.count ?? 1
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
			return getHeader(partOfSpeech: sections[section].name)
		} else {
			return nil
		}
	}
	
	private func getHeader(partOfSpeech: String) -> String {
		switch(partOfSpeech) {
		case Dictionary.PART_OF_SPEECH_NOUN:
			return NSLocalizedString("nouns", comment: "")
		case Dictionary.PART_OF_SPEECH_ADJECTIVE:
			return NSLocalizedString("adjectives", comment: "")
		case Dictionary.PART_OF_SPEECH_VERB:
			return NSLocalizedString("verbs", comment: "")
		case Dictionary.PART_OF_SPEECH_ADVERB:
			return NSLocalizedString("adverbs", comment: "")
		default: return ""
		}
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return fetchedResultsController?.sectionIndexTitles
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
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
	}
}
