//
//  MoreTableViewController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 25/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


	@IBOutlet weak var cellSharePoemText: UITableViewCell!
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		if cell == cellSharePoemText {
			let poemText = Poem.readDraft().text
			present(UIActivityViewController(activityItems: [poemText], applicationActivities: nil), animated:true, completion:nil)
		}
	}
}
