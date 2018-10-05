//
//  ThesaurusTableViewCell.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class ThesaurusTableViewCell: UITableViewCell {

	weak var delegate: ThesaurusTableViewCellDelegate? = nil
	@IBOutlet weak var labelWord: UILabel!
	
	@IBAction func searchRhymer(_ sender: UIButton) {
		delegate?.searchRhymer(query: labelWord.text!)

	}
	@IBAction func searchThesaurus(_ sender: UIButton) {
		delegate?.searchThesaurus(query: labelWord.text!)

	}
	@IBAction func searchDictionary(_ sender: UIButton) {
		delegate?.searchDictionary(query: labelWord.text!)
	}
	
}
protocol ThesaurusTableViewCellDelegate:class {
	func searchRhymer(query: String)
	func searchThesaurus(query: String)
	func searchDictionary(query: String)
}
