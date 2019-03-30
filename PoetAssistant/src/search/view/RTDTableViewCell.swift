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
	
	@IBOutlet weak var viewRTD: RTDView!
	
	func bind(word: String, isFavorite: Bool, showRTD: Bool,
			  rtdDelegate: RTDDelegate?, favoriteDelegate: FavoriteDelegate) {
		viewRTD.bind(word:word, isFavorite: isFavorite, showRTD: showRTD,
					 rtdDelegate: rtdDelegate, favoriteDelegate: favoriteDelegate)
		accessibilityElements = [viewRTD.labelWord!,
								 viewRTD.buttonFavorite!,
								 viewRTD.buttonRhymer!,
								 viewRTD.buttonThesaurus!,
								 viewRTD.buttonDictionary!]
	}
	
}
