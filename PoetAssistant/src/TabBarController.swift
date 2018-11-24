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

class TabBarController: UITabBarController, RTDDelegate {
	
	private var searchViewController: SearchViewController?
	
	override func viewWillAppear(_ animated: Bool) {
		preloadTabs()
		let composerViewController:ComposerViewController? = getTViewController()
		composerViewController?.rtdDelegate = self
		searchViewController = getTViewController()
	}

	// Hack to preload tab viewcontrollers
	// https://stackoverflow.com/questions/33261776/how-to-load-all-views-in-uitabbarcontroller
	// Without this, if the user navigates to the search view controller from the composer controller,
	// via the text selection popup, without having opened the search view controller at least once before,
	// the app crashes because the search view controller isn't initialized fully yet.
	private func preloadTabs() {
		for viewController in viewControllers! {
			let _ = viewController.view
			if let navController = viewController as? UINavigationController {
				if let topViewController = navController.topViewController {
					let _ = topViewController.view
				}
			}
		}
	}

	private func getTViewController<T>() -> T? {
		for viewController in viewControllers! {
			if viewController is T {
				return viewController as? T
			} else if viewController is UINavigationController {
				if let topViewController = (viewController as! UINavigationController).topViewController {
					if topViewController is T {
						return topViewController as? T
					}
				}
			}
		}
		return nil
	}
	
	func searchRhymer(query: String) {
		switchToSearchViewController()
		searchViewController?.searchRhymer(query:query)
	}
	
	func searchThesaurus(query: String) {
		switchToSearchViewController()
		searchViewController?.searchThesaurus(query:query)
	}
	
	func searchDictionary(query: String) {
		switchToSearchViewController()
		searchViewController?.searchDictionary(query:query)
	}
	func search(query: String) {
		switchToSearchViewController()
		searchViewController?.searchAllLexicons(query: query)
	}
	
	private func switchToSearchViewController() {
		selectedViewController = searchViewController?.navigationController
	}

}
