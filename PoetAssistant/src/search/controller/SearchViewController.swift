//
//  SearchViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 06/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, SearchSuggestionsDelegate, RTDDelegate {

	private var searchController: UISearchController? = nil

	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var rhymerContainer: UIView!
	@IBOutlet weak var thesaurusContainer: UIView!
	@IBOutlet weak var dictionaryContainer: UIView!
	@IBOutlet weak var searchContainer: UIView!
	private var rhymerController: RhymerViewController?
	private var thesaurusController: ThesaurusViewController?
	private var dictionaryController: DictionaryViewController?
	private var searchSuggestionsController: SearchSuggestionsController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showLexicon(lexicon: Settings.getLexicon())
		searchController = UISearchController(searchResultsController: nil)
		searchController?.searchResultsUpdater = searchSuggestionsController
		searchController?.obscuresBackgroundDuringPresentation = false
		searchController?.hidesNavigationBarDuringPresentation = false
		searchController?.dimsBackgroundDuringPresentation = false
		searchController?.definesPresentationContext = true
		searchController?.delegate = self
		searchController?.searchBar.delegate = self
		searchController?.searchBar.sizeToFit()
		searchController?.searchBar.placeholder = NSLocalizedString("search_placeholder", comment: "")
		searchController?.isActive = true
		navigationItem.titleView = searchController?.searchBar
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if (!hasQueryTerm()) {
			searchController?.searchBar.becomeFirstResponder()
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch (segue.identifier) {
		case "EmbedRhymer":
			rhymerController = segue.destination as? RhymerViewController
			rhymerController?.delegate = self
		case "EmbedThesaurus":
			thesaurusController = segue.destination as? ThesaurusViewController
			thesaurusController?.delegate = self
		case "EmbedDictionary":
			dictionaryController = segue.destination as? DictionaryViewController
		case "EmbedSearchSuggestions":
			searchSuggestionsController = segue.destination as? SearchSuggestionsController
			searchSuggestionsController?.delegate = self
		default: break
		}
		super.prepare(for: segue, sender: sender)
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
	func getSearchResultsController(lexicon: Lexicon) -> SearchResultsController? {
		switch(lexicon) {
		case .rhymer: return rhymerController
		case .thesaurus: return thesaurusController
		case .dictionary: return dictionaryController
		}
	}
	func searchRhymer(query: String) {
		wordSelected(word:query, lexicon: .rhymer)
	}
	func searchThesaurus(query: String) {
		wordSelected(word:query, lexicon: .thesaurus)
	}
	func searchDictionary(query: String) {
		wordSelected(word:query, lexicon: .dictionary)
	}
	private func wordSelected(word: String, lexicon: Lexicon) {
		getSearchResultsController(lexicon: lexicon)?.query = word
		showLexicon(lexicon:lexicon)
	}
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchContainer.isHidden = false
		searchSuggestionsController?.loadSuggestions(forQuery: searchBar.text)
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchContainer.isHidden = false
	}
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		handleSelection(selection: searchBar.text)
	}
	func didDismissSearchController(_ searchController: UISearchController) {
		handleSelection(selection: nil)
	}
	func didSelectSuggestion(suggestion: String) {
		searchController?.searchBar.text = suggestion
		handleSelection(selection: suggestion)
	}
	private func handleSelection(selection: String?) {
		if (selection != nil && !selection!.isEmpty) {
			rhymerController?.query = selection!
			thesaurusController?.query = selection!
			dictionaryController?.query = selection!
			Suggestion.addSuggestion(word: selection!)
		}
		searchSuggestionsController?.clear()
		searchContainer.isHidden = true
		searchController?.isActive = false
	}
}
