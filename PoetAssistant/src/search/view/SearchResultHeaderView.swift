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

protocol SearchResultHeaderDelegate:class {
	func didClickFavorite(word: String)
	func didClickLookup(word: String)
	func didClickPlay(word: String)
	func didClickShare(sender: UIView)
}

@IBDesignable
class SearchResultHeaderView: UIView {
	var contentView: UIView?

	weak var delegate: SearchResultHeaderDelegate?
	
	@IBOutlet weak var labelWord: UILabel!
	@IBOutlet weak var buttonFavorite: UIButton! {
		didSet {
			FavoriteButtonHelper.setupButton(button: buttonFavorite)
		}
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
	}
	@IBAction func didClickFavorite(_ sender: UIButton) {
		if let word = labelWord.text {
			delegate?.didClickFavorite(word: word)
		}
	}
	@IBAction func didClickLookup(_ sender: UIButton) {
		if let word = labelWord.text {
			delegate?.didClickLookup(word: word)
		}
	}
	@IBAction func didClickPlay(_ sender: UIButton) {
		if let word = labelWord.text {
			delegate?.didClickPlay(word: word)
		}
	}
	@IBAction func didClickShare(_ sender: UIButton) {
		delegate?.didClickShare(sender: sender)
	}
	private func xibSetup() {
		let bundle = Bundle(for: SearchResultHeaderView.self)
		let nib = UINib(nibName: "SearchResultHeaderView", bundle: bundle)
		guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
		view.frame = self.bounds
		self.addSubview(view)
		contentView = view
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		xibSetup()
		contentView?.prepareForInterfaceBuilder()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		xibSetup()
	}
}
