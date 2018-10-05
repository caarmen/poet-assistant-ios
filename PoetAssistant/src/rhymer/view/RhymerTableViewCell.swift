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

class RhymerTableViewCell: UITableViewCell {

	weak var delegate: RTDDelegate? = nil
	
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

