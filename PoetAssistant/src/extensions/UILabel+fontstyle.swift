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
			return hasTrait(trait: .traitBold)
		}
		set {
			setTrait(trait: .traitBold, enabled: newValue)
		}
	}
	
	@IBInspectable var italic: Bool {
		get {
			return hasTrait(trait: .traitItalic)
		}
		set {
			setTrait(trait: .traitItalic, enabled: newValue)
		}
	}
	
	private func setTrait(trait: UIFontDescriptor.SymbolicTraits, enabled: Bool) {
		var traits = UIFontDescriptor.SymbolicTraits(rawValue: font?.fontDescriptor.symbolicTraits.rawValue ?? 0)
		if (enabled && !traits.contains(trait)) {
			traits.insert(trait)
		} else if (!enabled && traits.contains(trait)) {
			traits.remove(.traitBold)
		}
		if let newDescriptor = font?.fontDescriptor.withSymbolicTraits(traits) {
			font = UIFont(descriptor: newDescriptor, size: 0)
		}
	}
	private func hasTrait(trait: UIFontDescriptor.SymbolicTraits) -> Bool {
		return font?.fontDescriptor.symbolicTraits.contains(trait) ?? false
	}
}
