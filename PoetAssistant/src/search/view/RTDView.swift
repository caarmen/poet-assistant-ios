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

@IBDesignable
class RTDView: UIView {

	var contentView: UIView?
	weak var rtdDelegate: RTDDelegate? = nil
	weak var favoriteDelegate: FavoriteDelegate? = nil
	
	@IBOutlet weak var constraintRTDLeading: NSLayoutConstraint!
	@IBOutlet weak var labelWord: UILabel!

	@IBOutlet weak var buttonFavorite: UIButton! {
		didSet {
			FavoriteButtonHelper.setupButton(button: buttonFavorite)
		}
	}
	@IBOutlet weak var buttonRhymer: UIButton!
	@IBOutlet weak var buttonThesaurus: UIButton!
	@IBOutlet weak var buttonDictionary: UIButton!

	// https://stackoverflow.com/questions/9282365/load-view-from-an-external-xib-file-in-storyboard
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
	}


	@IBAction func didClickFavorite(_ sender: UIButton) {
		// Technically we don't have to set the selected state here, as it
		// will be updated by the view controller after a data refresh.
		// However, this data refresh may take a moment, and we don't want
		// the app to appear slow.
		buttonFavorite.isSelected = !buttonFavorite.isSelected
		favoriteDelegate?.toggleFavorite(query: labelWord.text!)
	}
	@IBAction func didClickRhymer(_ sender: UIButton) {
		rtdDelegate?.searchRhymer(query: labelWord.text!)
	}
	@IBAction func didClickThesaurus(_ sender: UIButton) {
		rtdDelegate?.searchThesaurus(query: labelWord.text!)
	}
	@IBAction func didClickDictionary(_ sender: UIButton) {
		rtdDelegate?.searchDictionary(query: labelWord.text!)
	}
	
	func bind(word: String, isFavorite: Bool, showRTD: Bool,
			  rtdDelegate: RTDDelegate?, favoriteDelegate: FavoriteDelegate) {
		labelWord.text = word
		buttonFavorite.isSelected = isFavorite
		self.rtdDelegate = rtdDelegate
		self.favoriteDelegate = favoriteDelegate
		setRTDVisible(visible: showRTD, animate: false)
	}
	func toggleRTDVisibility() {
		setRTDVisible(visible: buttonRhymer.isHidden, animate: true)
	}
	func setRTDVisible(visible: Bool, animate: Bool) {
		RTDAnimator.setRTDVisible(rtdLeadingConstraint:constraintRTDLeading, buttonFavorite: buttonFavorite, rtdViews: [buttonRhymer, buttonThesaurus, buttonDictionary],
								  visible:visible, animate:animate)
	}
	
	private func xibSetup() {
		let bundle = Bundle(for: RTDView.self)
		let nib = UINib(nibName: "RTDView", bundle: bundle)
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
