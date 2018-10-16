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

class RTDTableViewCell: UITableViewCell {
	weak var rtdDelegate: RTDDelegate? = nil
	
	@IBOutlet weak var labelWord: UILabel!
	@IBOutlet weak var buttonRhymer: UIButton!
	@IBOutlet weak var buttonThesaurus: UIButton!
	@IBOutlet weak var buttonDictionary: UIButton!
	@IBOutlet weak var buttonMore: UIButton!
	@IBAction func searchRhymer(_ sender: UIButton) {
		rtdDelegate?.searchRhymer(query: labelWord.text!)
	}
	@IBAction func searchThesaurus(_ sender: UIButton) {
		rtdDelegate?.searchThesaurus(query: labelWord.text!)
	}
	@IBAction func searchDictionary(_ sender: UIButton) {
		rtdDelegate?.searchDictionary(query: labelWord.text!)
	}
	
	func toggleRTDVisibility() {
		setRTDVisible(visible: buttonRhymer.isHidden, animate: true)
	}
	func setRTDVisible(visible: Bool, animate: Bool) {
		RTDAnimator.setRTDVisible(buttonMore: buttonMore, rtdViews: [buttonRhymer, buttonThesaurus, buttonDictionary],
								  visible:visible, animate:animate)
	}

}
