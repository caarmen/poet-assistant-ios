//
//  UILabel+fontstyle.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 04/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

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
