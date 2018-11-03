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

class RTDAnimator {
	
	private static let ANIMATION_DURATION = TimeInterval(0.2)
	
	/**
	Show the RTD icons of the selected cell, and hide the RTD icons of all the other visible cells.
	*/
	class func setRTDVisible(selectedCell: RTDTableViewCell, visibleCells:[UITableViewCell]) {
		visibleCells.filter { $0 is RTDTableViewCell
			&& $0 != selectedCell
			&& !($0 as! RTDTableViewCell).buttonRhymer.isHidden}.forEach { cell in
				(cell as! RTDTableViewCell).setRTDVisible(visible: false, animate: true)
		}
		selectedCell.toggleRTDVisibility()
	}
	
	class func setRTDVisible(rtdLeadingConstraint: NSLayoutConstraint, buttonFavorite: UIButton, rtdViews: [UIView], visible: Bool, animate: Bool) {
		if (animate) {
			if visible {
				animateShowRTD(rtdLeadingConstraint: rtdLeadingConstraint, buttonFavorite: buttonFavorite, rtdViews: rtdViews)
			} else {
				animateHideRTD(rtdLeadingConstraint: rtdLeadingConstraint, buttonFavorite: buttonFavorite, rtdViews: rtdViews)
			}
		} else {
			buttonFavorite.isHidden = !visible && !buttonFavorite.isSelected
			rtdLeadingConstraint.priority = visible ? UILayoutPriority(rawValue: 999) : UILayoutPriority.defaultLow
			rtdViews.forEach {$0.isHidden = !visible}
		}
	}
	
	private class func animateHideRTD(rtdLeadingConstraint: NSLayoutConstraint, buttonFavorite: UIButton, rtdViews: [UIView]) {
		rtdViews.forEach { hideView(view: $0)}
		hideView(view: buttonFavorite) {
			rtdLeadingConstraint.priority = UILayoutPriority.defaultLow
			if buttonFavorite.isSelected {
				buttonFavorite.isHidden = false
			}
		}
	}
	
	private class func animateShowRTD(rtdLeadingConstraint: NSLayoutConstraint, buttonFavorite: UIButton, rtdViews: [UIView]) {
		rtdLeadingConstraint.priority = UILayoutPriority(rawValue: 999)
		rtdViews.forEach { showView(view: $0)}
		buttonFavorite.isHidden = true
		showView(view: buttonFavorite)
	}
	
	private class func hideView(view: UIView, completion:(() -> Void)? = nil) {
		if (!view.isHidden) {
			let origFrame = view.frame
			UIView.animate(withDuration: ANIMATION_DURATION, animations: {
				let newFrame = CGRect(x: UIScreen.main.bounds.width, y: origFrame.minY, width: origFrame.width, height: origFrame.height)
				view.frame = newFrame
				view.alpha = 0.0
			}, completion: { animationFinished in
				view.frame = origFrame
				view.isHidden = true
				view.alpha = 1.0
				completion?()
			})
		}
	}
	private class func showView(view: UIView) {
		if (view.isHidden) {
			let origFrame = view.frame
			let newFrame = CGRect(x: UIScreen.main.bounds.width, y: origFrame.minY, width: origFrame.width, height: origFrame.height)
			view.frame = newFrame
			view.isHidden = false
			view.alpha = 0.0
			UIView.animate(withDuration: ANIMATION_DURATION, animations: {
				view.frame = origFrame
				view.alpha = 1.0
			}, completion: { animationFinished in
			})
		}
	}
}
