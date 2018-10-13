//
//  MoreViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 13/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {

	@IBOutlet weak var settingsCell: UITableViewCell!
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if settingsCell == tableView.cellForRow(at: indexPath) {
			if let url = URL(string: UIApplication.openSettingsURLString) {
				UIApplication.shared.open(url, options:[:], completionHandler:nil)
			}
		}
	}

}
