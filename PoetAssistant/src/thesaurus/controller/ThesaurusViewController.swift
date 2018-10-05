//
//  SecondViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class ThesaurusViewController: SearchResultsController, ThesaurusTableViewCellDelegate {
	
	private var fetchedResultsController: ThesaurusFetchedResultsController? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tab = Tab.thesaurus
	}
	func searchRhymer(query: String) {
		postSearch(query:query, tab:.rhymer)
	}
	
	func searchThesaurus(query: String) {
		postSearch(query:query, tab:.thesaurus)
	}
	
	func searchDictionary(query: String) {
		postSearch(query:query, tab:.dictionary)
	}
	
	private func postSearch(query: String, tab: Tab) {
		var userInfo: [String:String] = [:]
		userInfo[Notification.Name.UserInfoKeys.query] = query
		userInfo[Notification.Name.UserInfoKeys.tab] = tab.rawValue
		NotificationCenter.`default`.post(
			name:Notification.Name.onquery,
			object:self,
			userInfo:userInfo)
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
			return NSLocalizedString(sections[section].name, comment: "")
		} else {
			return nil
		}
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return nil
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
			cellView.labelRelationship.text = "synonyms"
		case .antonym:
			cellView.labelRelationship.text = "antonyms"
		}
	}
	private func bindWordCell(cellView: ThesaurusTableViewCell, word: String) {
		cellView.labelWord.text = word
		cellView.delegate = self
		
	}
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
	}
}
