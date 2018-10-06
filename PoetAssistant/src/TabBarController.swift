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

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	
	private var tabToViewController = [Tab:UIViewController]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisibilityChanged), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	// Make sure keyboard doesn't cover the tab bar, by placing the tab bar above the keyboard,
	// when the keyboard becomes visible.
	// https://stackoverflow.com/questions/5272267/keyboard-hides-tabbar/14782487#14782487
	// https://stackoverflow.com/questions/7842806/check-for-split-keyboard/13495680#13495680
	@objc func keyboardVisibilityChanged(notification: Notification) {
		if let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
			let newTabBarY = keyboardFrame.origin.y - tabBar.frame.size.height
			let newTabBarFrame = CGRect(x: tabBar.frame.origin.x, y: newTabBarY, width: tabBar.frame.width, height: tabBar.frame.height)
			tabBar.frame = newTabBarFrame
		}
	}
}
