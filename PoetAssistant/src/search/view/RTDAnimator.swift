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
		visibleCells.filter { $0 is RTDTableViewCell && $0 != selectedCell}.forEach { cell in
			(cell as! RTDTableViewCell).setRTDVisible(visible: false, animate: true)
		}
		selectedCell.toggleRTDVisibility()
	}
	
	class func setRTDVisible(rtdViews: [UIView], visible: Bool, animate: Bool) {
		if (animate) {
			if (visible) {
				rtdViews.forEach { showView(view: $0)}
			} else {
				rtdViews.forEach { hideView(view: $0)}
			}
		} else {
			rtdViews.forEach {$0.isHidden = !visible}
		}
	}
	
	private class func hideView(view: UIView) {
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
