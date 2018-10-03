//
//  TabBarController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 03/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisibilityChanged), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
		let toto = AppDelegate.persistentContainer
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
			if let animationDuration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Float {
				UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self] in
					self?.tabBar.frame = newTabBarFrame
				})
			}
		}
	}
}
