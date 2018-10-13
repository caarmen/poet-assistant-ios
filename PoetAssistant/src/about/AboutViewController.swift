//
//  AboutViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 13/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {

	@IBAction func didClickSourceCode(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios")
	}
	@IBAction func didClickReportBugs(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/issues")
	}
	@IBAction func didClickPrivacyPolicy(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/PRIVACY.md")
	}

	@IBAction func didClickPoetAssistantLicense(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE.txt")
	}
	
	@IBAction func didClickRhymerLicense(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE-rhyming-dictionary.txt")
	}
	
	@IBAction func didClickThesaurusLicense(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE-thesaurus-wordnet.txt")
	}

	@IBAction func didClickDictionaryLicense(_ sender: UIButton) {
		openUrl(urlString: "https://github.com/caarmen/poet-assistant-ios/blob/master/LICENSE-dictionary-wordnet.txt")
	}
	
	@IBAction func didClickPorterStemmer(_ sender: UIButton) {
		openUrl(urlString: "https://tartarus.org/martin/PorterStemmer/")
	}

	private func openUrl(urlString: String) {
		if let url = URL(string: urlString) {
			UIApplication.shared.open(url, options:[:], completionHandler:nil)
		}
	}
}
