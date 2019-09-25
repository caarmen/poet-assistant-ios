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
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, FavoriteDelegate {

	private lazy var favoritesFetchedResultsController: NSFetchedResultsController<Favorite> = {
		let controller = Favorite.createFetchedResultsController(context: AppDelegate.persistentUserDbContainer.viewContext)
		controller.delegate = self
		return controller
	}()
	
	private var efficientLayoutEnabled = false {
		didSet {
			if oldValue != efficientLayoutEnabled {
				tableView.reloadData()
			}
		}
	}
	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var labelEmptyText: UILabel!
	weak var rtdDelegate: RTDDelegate?
	

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		fetch()
	}
	
	private func fetch() {
		do {
			try favoritesFetchedResultsController.performFetch()
		} catch let error {
			print ("Error fetching favorites: \(error)")
		}
		updateUI()
	}

	@IBAction func didClickDeleteAll(_ sender: UIButton) {
		presentClearFavoritesDialog()
	}
	private func presentClearFavoritesDialog() {
		let alert = UIAlertController(
			title: NSLocalizedString("delete_favorites_dialog_title", comment: ""),
			message: nil,
			preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(
			title: NSLocalizedString("delete_favorites_action_delete", comment: ""),
			style: UIAlertAction.Style.destructive, handler: { action in
				Favorite.clearFavorites() {[weak self] in
					self?.fetch()
				}
		}))
		alert.addAction(UIAlertAction(
			title: NSLocalizedString("delete_favorites_action_cancel", comment: ""),
			style: UIAlertAction.Style.cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		updateUI()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		efficientLayoutEnabled = Settings.getEfficientLayoutEnabled()
	}
	private func updateUI() {
		tableView.reloadData()
		if tableView.numberOfSections == 0 || tableView.numberOfRows(inSection: 0) == 0 {
			labelEmptyText.isHidden = false
			tableView.isHidden = true
		} else {
			labelEmptyText.isHidden = true
			tableView.isHidden = false
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return favoritesFetchedResultsController.sections?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let section = favoritesFetchedResultsController.sections?[section] {
			return section.numberOfObjects
		}
		return 0
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as? RTDTableViewCell {
			let favorite = favoritesFetchedResultsController.object(at: indexPath)
			cell.bind(word: favorite.word!,
					  isFavorite: true,
					  showRTD: efficientLayoutEnabled,
					  rtdDelegate: rtdDelegate,
					  favoriteDelegate: self)
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !efficientLayoutEnabled, let selectedCell = tableView.cellForRow(at: indexPath) as? RTDTableViewCell {
			RTDAnimator.setRTDVisible(selectedCell: selectedCell, visibleCells: tableView.visibleCells)
		}
	}
}
