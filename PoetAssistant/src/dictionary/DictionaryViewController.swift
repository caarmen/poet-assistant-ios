//
//  DictionaryViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import CoreData

class DictionaryViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
	private var searchController: UISearchController? = nil
	private var searchResultsController: SearchResultsController? = nil
	private var searchResultHeaderViewController: SearchResultHeaderViewController? = nil

	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var tableView: UITableView!
	private var query : String? {
		didSet {
			updateUI()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//searchResultsController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsController)
		searchResultsController?.didSelect = { [weak self] selection in
			self?.query = selection
			self?.searchResultsController?.dismiss(animated: true, completion: nil)
			self?.updateUI()
		}
		searchController = UISearchController(searchResultsController: searchResultsController)
		searchController?.searchResultsUpdater = searchResultsController
		searchController?.obscuresBackgroundDuringPresentation = false
		searchController?.hidesNavigationBarDuringPresentation = false
		searchController?.delegate = self
		searchController?.searchBar.delegate = self
		if let searchBar = searchController?.searchBar {
			toolbar.addSubview(searchBar)
		}
		//tableView.tableHeaderView = searchController?.searchBar
		definesPresentationContext = true
		updateUI()
	}
	
	override func addChild(_ childController: UIViewController) {
		if (childController is SearchResultHeaderViewController) {
			searchResultHeaderViewController = childController as? SearchResultHeaderViewController
		}
	}

	func didDismissSearchController(_ searchController: UISearchController) {
		query = nil
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		query = searchBar.text
	}
	
	private func updateUI() {
		searchResultHeaderViewController?.word.text = query
	}
}
