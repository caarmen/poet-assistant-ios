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
import PoetAssistantLexiconsFramework

class WotdTableViewController: UITableViewController {
	
	private var wotdEntries: [WotdEntry] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
	}
	
	private func loadData() {
		CoreDataAccess.persistentDictionariesContainer.performBackgroundTask() { context in
			let result = Wotd.getLastWordsOfTheDay(context: context, count: 100)
			DispatchQueue.main.async { [weak self] in
				self?.wotdEntries = result
				self?.tableView.reloadData()
			}
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return wotdEntries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WotdCell", for: indexPath)
		let wotdEntry = wotdEntries[indexPath.row]
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeStyle = DateFormatter.Style.none
		let dateString = dateFormatter.string(from: wotdEntry.date)
		cell.textLabel?.text = wotdEntry.word
		cell.detailTextLabel?.text = dateString
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		AppDelegate.search(query: wotdEntries[indexPath.row].word)
	}
}
