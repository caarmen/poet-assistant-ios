//
//  TodayViewController.swift
//  PoetAssistantTodayExtension
//
//  Created by Carmen Alvarez on 25/11/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import NotificationCenter
import PoetAssistantLexiconsFramework

class TodayViewController: UIViewController, NCWidgetProviding {
	@IBOutlet weak var labelTitle: UILabel!
	
	@IBOutlet weak var labelDefinitions: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view from its nib.
	}
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		if (activeDisplayMode == .compact) {
			self.preferredContentSize = maxSize;
		}
		else {
			resizeToFitWhyDoesntAutoLayoutWork()
		}
	}
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		CoreDataAccess.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			let wotd = Wotd.getWordOfTheDay(context: context)
			if let wotdDefinitions = Dictionary.fetch(context: context, queryText: wotd)?.getDefinitionsText() {
				DispatchQueue.main.async {
					self?.labelTitle.text = wotd
					var definitions = wotdDefinitions
					definitions.append("line1\nline2\nline3")
					self?.labelDefinitions.text = definitions
					self?.resizeToFitWhyDoesntAutoLayoutWork()
					self?.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
				}
			}
		}
		completionHandler(NCUpdateResult.newData)
	}
	
	private func resizeToFitWhyDoesntAutoLayoutWork() {
		self.preferredContentSize = CGSize(
			width: self.preferredContentSize.width,
			height: getContentHeight())
	}
	private func getContentHeight() -> CGFloat {
		return labelTitle.intrinsicContentSize.height
			+ labelTitle.layoutMargins.top
			+ labelTitle.layoutMargins.bottom
			+ labelDefinitions.intrinsicContentSize.height
			+ labelDefinitions.layoutMargins.top
			+ labelDefinitions.layoutMargins.bottom
	}
	
	//widgetLargestAvailableDisplayMode: NCWidgetDisplayMode  = NCWidgetDisplayMode.expanded
	
}
