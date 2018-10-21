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

class AboutViewController: UITableViewController {
	
	@IBOutlet weak var cellSourceCode: UITableViewCell!
	
	@IBOutlet weak var cellReportBugs: UITableViewCell!
	
	@IBOutlet weak var cellPrivacyPolicy: UITableViewCell!
	
	@IBOutlet weak var cellPoetAssistantLicense: UITableViewCell!
	
	@IBOutlet weak var cellRhymerLicense: UITableViewCell!
	
	@IBOutlet weak var cellThesaurusLicense: UITableViewCell!
	
	@IBOutlet weak var cellDictionaryLicense: UITableViewCell!
	
	@IBOutlet weak var cellPorterStemmer: UITableViewCell!

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = tableView.cellForRow(at: indexPath)
		switch(selectedCell) {
		case cellSourceCode: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios")
		case cellReportBugs: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/issues")
		case cellPrivacyPolicy: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/PRIVACY.md")
		case cellPoetAssistantLicense: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE.txt")
		case cellRhymerLicense: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE-rhyming-dictionary.txt")
		case cellThesaurusLicense: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE-thesaurus-wordnet.txt")
		case cellDictionaryLicense: openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE-dictionary-wordnet.txt")
		case cellPorterStemmer: openUrl(urlString: "https://tartarus.org/martin/PorterStemmer/")
		default: break
		}
		tableView.deselectRow(at: indexPath, animated: true)

	}
	private func openUrl(urlString: String) {
		if let url = URL(string: urlString) {
			UIApplication.shared.open(url, options:[:], completionHandler:nil)
		}
	}
}
