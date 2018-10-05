//
//  FirstViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class RhymerViewController: SearchResultsController, RhymerTableViewCellDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		tab = Tab.rhymer
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
	
	private var fetchedResultsController: CombinedFetchedResultsController<NSDictionary>? = nil
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No rhymes for %@", comment: ""), "\(query)")
	}
	override func doQuery(query: String, completion: @escaping () -> Void) {
		AppDelegate.persistentContainer.performBackgroundTask { [weak self] context in
			self?.fetchedResultsController = WordVariants.createFetchResultsController(context: context, queryText: query)
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
				return String(format: NSLocalizedString("rhyme_variant_match_type_\(rhymeType)", comment: ""), query!, variantNumber)
			} else {
				return NSLocalizedString("rhyme_match_type_\(sectionName)", comment: "")
			}
		} else {
			return nil
		}
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return nil
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let rhymerWordCell = tableView.dequeueReusableCell(withIdentifier: "RhymerWordCell") as? RhymerTableViewCell {
			if let rhymerWord = fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) {
				rhymerWordCell.labelWord.text = rhymerWord[WordVariants.COLUMN_WORD] as? String
				rhymerWordCell.delegate = self
			}
			return rhymerWordCell
		}
		return UITableViewCell()
	}
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return -1
	}
}

