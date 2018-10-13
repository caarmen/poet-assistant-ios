//
//  AboutViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 13/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

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
