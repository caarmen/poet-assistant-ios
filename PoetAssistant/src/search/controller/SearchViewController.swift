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

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, SearchSuggestionsDelegate, RTDDelegate {

	private var searchController: UISearchController? = nil

	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var favoritesContainer: UIView!
	@IBOutlet weak var rhymerContainer: UIView!
	@IBOutlet weak var thesaurusContainer: UIView!
	@IBOutlet weak var dictionaryContainer: UIView!
	@IBOutlet weak var searchContainer: UIView!
	private var rhymerController: RhymerViewController?
	private var thesaurusController: ThesaurusViewController?
	private var dictionaryController: DictionaryViewController?
	private var favoritesController: FavoritesViewController?
	private var searchSuggestionsController: SearchSuggestionsController?
	private var rightButtonBarItem: UIBarButtonItem?
	
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
		navigationItem.hidesSearchBarWhenScrolling = false
		rightButtonBarItem = navigationItem.rightBarButtonItem
		definesPresentationContext = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.backgroundColor = Settings.getTheme().backgroundColor
		if let searchBar = searchController?.searchBar {
			navigationItem.titleView = searchBar
			Settings.getTheme().applyTextFieldTint(view: searchBar, color: Settings.getTheme().controlColor)
		}
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
			rhymerController?.rtdDelegate = self
		case "EmbedThesaurus":
			thesaurusController = segue.destination as? ThesaurusViewController
			thesaurusController?.rtdDelegate = self
		case "EmbedDictionary":
			dictionaryController = segue.destination as? DictionaryViewController
		case "EmbedFavorites":
			favoritesController = segue.destination as? FavoritesViewController
			favoritesController?.rtdDelegate = self
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
		case 3: return favoritesContainer
		default: return nil
		}
	}
	private func getSegmentedControlIndex(lexicon: Lexicon) -> Int {
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
		let segmentedControlIndex = getSegmentedControlIndex(lexicon: lexicon)
		if (segmentedControl.selectedSegmentIndex != segmentedControlIndex) {
			segmentedControl.selectedSegmentIndex = segmentedControlIndex
		}
		showSelectedSegment()
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
		favoritesContainer.isHidden = true
		container!.isHidden = false
	}
	private func getSearchResultsController(lexicon: Lexicon) -> SearchResultsController? {
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
		if (searchBar.text == nil || searchBar.text!.isEmpty) {
			searchSuggestionsController?.loadSuggestions(forQuery: searchBar.text)
		}
		tabBarController?.tabBar.isHidden = true
		navigationItem.rightBarButtonItem = nil
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchContainer.isHidden = false
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		handleSelection(selection: searchBar.text)
	}
	func didDismissSearchController(_ searchController: UISearchController) {
		handleSelection(selection: nil)
	}
	func didSelectSuggestion(suggestion: String) {
		searchController?.searchBar.text = suggestion
		handleSelection(selection: suggestion)
	}
	func didSelectRandomWord() {
		AppDelegate.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			let randomWord = Stems.findRandomWord(context: context)
			DispatchQueue.main.async { [weak self] in
				self?.handleSelection(selection: randomWord, persistSuggestion: false)
				self?.showLexicon(lexicon: .dictionary)
			}
		}
	}
	func didClearSearchHistory() {
		handleSelection(selection:nil)
	}
	private func handleSelection(selection: String?, persistSuggestion: Bool = true) {
		if (selection != nil && !selection!.isEmpty) {
			let selectionLowerCase = selection!.localizedLowercase
			rhymerController?.query = selectionLowerCase
			thesaurusController?.query = selectionLowerCase
			dictionaryController?.query = selectionLowerCase
			if (persistSuggestion) {
				Suggestion.addSuggestion(word: selectionLowerCase)
			}
		}
		searchSuggestionsController?.clear()
		searchContainer.isHidden = true
		searchController?.isActive = false
		tabBarController?.tabBar.isHidden = false
		navigationItem.rightBarButtonItem = rightButtonBarItem
	}
}
