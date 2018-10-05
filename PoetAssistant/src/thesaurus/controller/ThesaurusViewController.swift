//
//  SecondViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class ThesaurusViewController: SearchResultsController {
	
	private var fetchedResultsController: ThesaurusFetchedResultsController? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tab = Tab.thesaurus
	}
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No synonyms for %@", comment: ""), "\(query)")
	}
	
	override func doQuery(query: String, completion: @escaping () -> Void) {
		AppDelegate.persistentContainer.performBackgroundTask { [weak self] context in
			self?.fetchedResultsController = Thesaurus.createFetchResultsController(context: context, queryText: query)
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
			return sections[section].name
		} else {
			return nil
		}
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return fetchedResultsController?.sectionIndexTitles
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let thesaurusCell = tableView.dequeueReusableCell(withIdentifier: "ResultListCell") as? ThesaurusTableViewCell {
			if let thesaurusListItem = fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) {
				switch (thesaurusListItem) {
				case .subtitle (let subtitle):
					if (subtitle == .synonym) {
						thesaurusCell.labelQuery.text = "synonyms"
					} else {
						thesaurusCell.labelQuery.text = "antonyms"
					}
				case .word (let word):
					thesaurusCell.labelQuery.text = word
				}
				//thesaurusCell.delegate = self
			}
			return thesaurusCell
		}
		return UITableViewCell()
	}
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
	}
}

