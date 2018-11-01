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

import CoreData

class CoreDataNotificationHelper {
	private init() {
		// prevent instantiation
	}
	
	class func isNotificationForFavorites(notification: Notification) -> Bool {
		return isNotificationForType(notification: notification, type: Favorite.self)
	}

	private class func isNotificationForType(notification: Notification, type: NSManagedObject.Type) -> Bool{
		if let userInfo = notification.userInfo {
			return isEntryValueOfType(userInfo: userInfo, entryKey: NSInsertedObjectsKey, requestedType: type)
				|| isEntryValueOfType(userInfo: userInfo, entryKey: NSUpdatedObjectsKey, requestedType: type)
				|| isEntryValueOfType(userInfo: userInfo, entryKey: NSDeletedObjectsKey, requestedType: type)
		}
		return false
	}
	
	private class func isEntryValueOfType(userInfo: Swift.Dictionary<AnyHashable, Any>,
										  entryKey: String,
										  requestedType: NSManagedObject.Type) -> Bool {
		if let modifiedObjectsOfType = userInfo[entryKey] as? Set<NSManagedObject> {
			if let modifiedObject = modifiedObjectsOfType.first {
				let typeOfModifiedObject = type(of: modifiedObject)
				return typeOfModifiedObject == requestedType
			}
		}
		return false
	}
}
