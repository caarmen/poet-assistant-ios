//
//  VoiceTableViewCell.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 14/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

protocol VoiceTableViewCellDelegate:class {
	func didClickPlayButton(sender: UITableViewCell)
}
class VoiceTableViewCell: UITableViewCell {

	weak var delegate: VoiceTableViewCellDelegate? = nil
	
	@IBOutlet weak var labelVoiceName: UILabel!
	@IBOutlet weak var labelVoiceQuality: UILabel!
	
	@IBAction func didClickPlayButton(_ sender: UIButton) {
		delegate?.didClickPlayButton(sender: self)
	}
}
