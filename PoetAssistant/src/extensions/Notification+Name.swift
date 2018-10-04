//
//  NSNotification+Name.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 04/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import Foundation

extension Notification.Name {
	struct UserInfoKeys {
		static let query = "query"
	}
	static let onquery = Notification.Name("on-query")
}
