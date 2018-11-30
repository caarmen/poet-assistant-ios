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
import NotificationCenter
import PoetAssistantLexiconsFramework

class TodayViewController: UIViewController, NCWidgetProviding {
	
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelDefinitions: UILabel!
	@IBOutlet weak var stackView: UIStackView!
	
	@IBOutlet weak var constraintTop: NSLayoutConstraint!
	@IBOutlet weak var constraintCenter: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
		let tap = UITapGestureRecognizer(target: self, action: #selector(searchWord))
		labelTitle.isUserInteractionEnabled = true
		labelDefinitions.isUserInteractionEnabled = true
		view.isUserInteractionEnabled = true
		labelTitle.addGestureRecognizer(tap)
		labelDefinitions.addGestureRecognizer(tap)
		view.addGestureRecognizer(tap)
		loadFromCache()
	}
	
	@objc
	func searchWord(sender:UITapGestureRecognizer) {
		if let queryWord = labelTitle.text {
			// Would like the URL to be defined only once. Currently it's referenced from
			// this extension and the Info.plist of the main app target.
			if let url = URL(string: "poetassistant://query/\(queryWord)") {
				self.extensionContext?.open(url)
			}
		}
	}

	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		if (activeDisplayMode == .compact) {
			self.labelDefinitions.isHidden = true
			self.stackView.alignment = .center
			self.constraintCenter.priority = UILayoutPriority.defaultHigh
			self.constraintTop.priority = UILayoutPriority.defaultLow
			view.layoutSubviews()
			self.preferredContentSize.height = stackView.bounds.height
		}
		else if self.labelTitle?.text?.count ?? 0 > 0{
			self.labelDefinitions.isHidden = false
			self.stackView.alignment = .leading
			self.constraintCenter.priority = UILayoutPriority.defaultLow
			self.constraintTop.priority = UILayoutPriority.defaultHigh
			view.layoutSubviews()
			self.preferredContentSize.height = stackView.bounds.height
		}
	}
	
	private func loadFromCache() {
		if let widgetData = WidgetDataRepository.loadFromCache() {
			labelTitle.text = widgetData.word
			labelDefinitions.text = widgetData.definitions
		}
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		WidgetDataRepository.loadFromDb() { [weak self] widgetData in
			if widgetData == nil {
				completionHandler(NCUpdateResult.noData)
			} else if widgetData?.word != self?.labelTitle.text || widgetData?.definitions != self?.labelDefinitions.text {
				completionHandler(NCUpdateResult.newData)
				self?.labelTitle.text = widgetData?.word
				self?.labelDefinitions.text = widgetData?.definitions
			}
		}
	}
}
