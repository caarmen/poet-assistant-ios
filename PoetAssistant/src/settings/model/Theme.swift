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

struct Theme {
	let name: String
	let controlColor: UIColor
	let primaryTextColor: UIColor
	let secondaryTextColor: UIColor
	let backgroundColor: UIColor
	let segmentedControlColor: UIColor
	let tableSectionBackground: UIColor
	let navigationBarStyle: UIBarStyle
	let navigationBarIsTranslucent: Bool
	
	static let LIGHT_THEME = Theme(
		name: "light",
		controlColor: toColor(hexColor: 0x607D8B),
		primaryTextColor: toColor(hexColor: 0x212121),
		secondaryTextColor: toColor(hexColor: 0x727272),
		backgroundColor: UIColor.white,
		segmentedControlColor: toColor(hexColor: 0x607D8B),
		tableSectionBackground: UIColor.groupTableViewBackground,
		navigationBarStyle: .default,
		navigationBarIsTranslucent: true)
	
	static let DARK_THEME = Theme(
		name: "dark",
		controlColor: toColor(hexColor: 0x607D8B),
		primaryTextColor: toColor(hexColor: 0xcccccc),
		secondaryTextColor: toColor(hexColor: 0x727272),
		backgroundColor: toColor(hexColor: 0x333333),
		segmentedControlColor: toColor(hexColor: 0xeeeeee),
		tableSectionBackground: UIColor.darkGray,
		navigationBarStyle: .black,
		navigationBarIsTranslucent: false)

	private static let THEMES : Swift.Dictionary = [LIGHT_THEME.name: LIGHT_THEME, DARK_THEME.name: DARK_THEME]
	
	static func getTheme(name: String) -> Theme {
		if let theme = THEMES[name] {
			return theme
		}
		return LIGHT_THEME
	}
	func apply() {
		tintNavigationBar()
		tintSearchBar()
		tintSegmentedControl()
		tintTables()
		tintCustomViews()
		tintGlobalViews()
	}
	// https://stackoverflow.com/questions/20875107/force-view-controller-to-reload-to-refresh-uiappearance-changes
	func reload(window: UIWindow) {
		for view in window.subviews {
			view.removeFromSuperview()
			window.addSubview(view)
		}
		// update the status bar if you change the appearance of it.
		window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
	}
	private func tintTables() {
		UITableView.appearance().backgroundColor = backgroundColor
		UITableViewCell.appearance().backgroundColor = backgroundColor
		UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.classForCoder() as! UIAppearanceContainer.Type]).backgroundColor = tableSectionBackground
	}
	private func tintNavigationBar() {
		UINavigationBar.appearance().barStyle = navigationBarStyle
		UINavigationBar.appearance().isTranslucent = navigationBarIsTranslucent
		UINavigationBar.appearance().barTintColor = backgroundColor
	}
	private func tintSearchBar() {
		UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([
			NSAttributedString.Key.backgroundColor: backgroundColor,
			NSAttributedString.Key.foregroundColor: UIColor.white
			], for: .normal)
		UISearchBar.appearance().backgroundColor = controlColor
		UISearchBar.appearance().tintColor = controlColor
	}
	private func tintSegmentedControl() {
		UIImageView.appearance(whenContainedInInstancesOf: [UISegmentedControl.classForCoder() as! UIAppearanceContainer.Type]).tintColor = segmentedControlColor
	}
	private func tintCustomViews() {
		SearchResultHeaderView.appearance().backgroundColor = backgroundColor
		RTDView.appearance().backgroundColor = backgroundColor
	}
	private func tintGlobalViews() {
		UIButton.appearance().tintColor = controlColor
		UITextView.appearance().textColor = primaryTextColor
		UILabel.appearance().textColor = primaryTextColor
	}
	// https://stackoverflow.com/questions/21453838/cursor-invisible-in-uisearchbar-ios-7/42444940#42444940
	// Workaround to have a dark cursor yet a light "Cancel" text.
	func applyTextFieldTint(view: UIView, color: UIColor) {
		if view is UITextField {
			view.tintColor = color
		} else {
			view.subviews.forEach {applyTextFieldTint(view:$0, color:color)}
		}
	}
	
	// https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
	private static func toColor(hexColor: Int) -> UIColor {
		let red = CGFloat((hexColor >> 16) & 0xFF)/255.0
		let green = CGFloat((hexColor >> 8) & 0xFF)/255.0
		let blue = CGFloat(hexColor & 0xFF)/255.0
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}
}
