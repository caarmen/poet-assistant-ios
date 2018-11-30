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

import Foundation
class Localization {
	class func localize(stringId: String, args: CVarArg...) -> String {
		let translatedPattern = NSLocalizedString(
			stringId,
			tableName: nil,
			bundle: Bundle(for: Localization.self),
			comment: "")

		// https://stackoverflow.com/questions/42428504/swift-3-issue-with-cvararg-being-passed-multiple-times?rq=1
		return withVaList(args) { argsPointer in
			return NSString(format: translatedPattern, arguments: argsPointer) as String
		}
	}
}
