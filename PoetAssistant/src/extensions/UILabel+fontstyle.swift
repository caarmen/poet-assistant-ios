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
extension UILabel {
	@IBInspectable var bold: Bool {
		get {
			return isBold()
		}
		set {
			setBold(isBold: newValue)
		}
	}
	func setBold(isBold: Bool) {
		var traits = UIFontDescriptor.SymbolicTraits(rawValue: font?.fontDescriptor.symbolicTraits.rawValue ?? 0)
		if (isBold && !traits.contains(.traitBold)) {
			traits.insert(.traitBold)
		} else if (!isBold && traits.contains(.traitBold)) {
			traits.remove(.traitBold)
		}
		if let newDescriptor = font?.fontDescriptor.withSymbolicTraits(traits) {
			font = UIFont(descriptor: newDescriptor, size: 0)
		}
	}
	func isBold() -> Bool {
		return font?.fontDescriptor.symbolicTraits.contains(.traitBold) ?? false
	}
}
