//
//  SearchViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 06/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	
	private var notificationObserver: NSObjectProtocol? = nil
	
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var rhymerContainer: UIView!
	@IBOutlet weak var thesaurusContainer: UIView!
	@IBOutlet weak var dictionaryContainer: UIView!
	private var rhymerController: SearchResultsController?
	private var thesaurusController: SearchResultsController?
	private var dictionaryController: SearchResultsController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showLexicon(lexicon: Settings.getLexicon())
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch (segue.identifier) {
		case "EmbedRhymer": rhymerController = segue.destination as? SearchResultsController
		case "EmbedThesaurus": thesaurusController = segue.destination as? SearchResultsController
		case "EmbedDictionary": dictionaryController = segue.destination as? SearchResultsController
		default: break
		}
		super.prepare(for: segue, sender: sender)
	}
	override func viewWillAppear(_ animated: Bool) {
		addNotificationObserver()
		if !hasQueryTerm() {
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "ShowSearchController", sender: self)
			}
		}
	}
	
	private func hasQueryTerm() -> Bool {
		if !(rhymerController?.query.isEmpty ?? true) {
			return true
		}
		if !(thesaurusController?.query.isEmpty ?? true) {
			return true
		}
		if !(dictionaryController?.query.isEmpty ?? true) {
			return true
		}
		return false
	}
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.`default`.removeObserver(self)
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		showSelectedSegment()
	}
	
	private func getContainerForSegmentedControlIndex(index: Int) -> UIView? {
		switch(index) {
		case 0: return rhymerContainer
		case 1: return thesaurusContainer
		case 2: return dictionaryContainer
		default: return nil
		}
	}
	private func getSegmentedControlIndex(lexicon: Lexicon) -> Int? {
		switch(lexicon) {
		case .rhymer: return 0
		case .thesaurus: return 1
		case .dictionary: return 2
		}
	}
	private func getSelectedLexicon() -> Lexicon {
		switch(segmentedControl.selectedSegmentIndex){
		case 0: return .rhymer
		case 1: return .thesaurus
		case 2: return .dictionary
		default: return .rhymer
		}
	}
	private func showLexicon(lexicon: Lexicon) {
		if let segmentedControlIndex = getSegmentedControlIndex(lexicon: lexicon) {
			if (segmentedControl.selectedSegmentIndex != segmentedControlIndex) {
				segmentedControl.selectedSegmentIndex = segmentedControlIndex
			}
			showSelectedSegment()
		}
	}
	private func showSelectedSegment () {
		let selectedContainer = getContainerForSegmentedControlIndex(index: segmentedControl.selectedSegmentIndex)
		showContainer(container: selectedContainer)
		Settings.setLexicon(lexicon: getSelectedLexicon())
	}
	
	private func showContainer(container: UIView?) {
		if container == nil {
			return
		}
		rhymerContainer.isHidden = true
		thesaurusContainer.isHidden = true
		dictionaryContainer.isHidden = true
		container!.isHidden = false
	}
	private func addNotificationObserver() {
		if (notificationObserver != nil) {
			NotificationCenter.`default`.removeObserver(notificationObserver!)
		}
		notificationObserver = NotificationCenter.`default`.addObserver(
			forName: Notification.Name.onquery,
			object:nil,
			queue:OperationQueue.main,
			using: { [weak self] notification in
				let notificationLexicon = notification.userInfo?[Notification.Name.UserInfoKeys.lexicon] as? String
				if (notificationLexicon != nil) {
					self?.showLexicon(lexicon: Lexicon(rawValue: notificationLexicon!)!)
				}
				self?.dismiss(animated: true, completion: nil)
		})
	}
	
}
