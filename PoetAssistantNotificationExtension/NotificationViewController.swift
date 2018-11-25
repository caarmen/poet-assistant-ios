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

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        //self.label?.text = notification.request.content.body
		//self.label?.text = AppDelegate.
    }

}
