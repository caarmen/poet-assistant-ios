//
//  NotificationViewController.swift
//  PoetAssistantNotificationExtension
//
//  Created by Carmen Alvarez on 25/11/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import PoetAssistantLexiconsFramework

class NotificationViewController: UIViewController, UNNotificationContentExtension {
	
	@IBOutlet var notifTitle: UILabel?
	
	@IBOutlet weak var notifLabel: UILabel?
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any required interface initialization here.
	}
	
	func didReceive(_ notification: UNNotification) {
		CoreDataAccess.persistentDictionariesContainer.performBackgroundTask { [weak self] context in
			let wotd = Wotd.getWordOfTheDay(context: context)
			if let wotdDefinitions = Dictionary.fetch(context: context, queryText: wotd)?.getDefinitionsText() {
				DispatchQueue.main.async {
					self?.notifTitle?.text = wotd
					self?.notifLabel?.text = wotdDefinitions
				}
			}
		}
	}
}
