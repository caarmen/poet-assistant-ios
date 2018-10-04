//
//  FirstViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class RhymerViewController: SearchResultsController {
	
	override func getEmptyText(query: String) -> String {
		return String(format: NSLocalizedString("No rhymes for %@", comment: ""), "\(query)")
	}
	override func doQuery(query: String, completion: @escaping () -> Void) {
	}
}

