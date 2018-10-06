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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showLexicon(lexicon: Settings.getLexicon())
	}
	
	override func viewWillAppear(_ animated: Bool) {
		addNotificationObserver()
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
	/*
	private func getContainerForTab(tab: Tab) -> UIView? {
		switch(tab) {
		case .rhymer: return rhymerContainer
		case .thesaurus: return thesaurusContainer
		case .dictionary: return dictionaryContainer
		default: return nil
		}
	}*/
	
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
