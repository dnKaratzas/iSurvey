//
//  UIKit+Localizable.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import UIKit

internal protocol Localizable {
	var localized: String { get }
}

// swiftlint:disable nslocalizedstring_key
extension String: Localizable {
	var localized: String {
		return NSLocalizedString(self, bundle: Bundle.main, comment: "")
	}
}
// swiftlint:enable nslocalizedstring_key

internal protocol SBLocalizable {
	var translationKey: String? { get set }
}

extension UILabel: SBLocalizable {
	@IBInspectable var translationKey: String? {
		get { return nil }
		set(key) {
			text = key?.localized
		}
	}
}

extension UIButton: SBLocalizable {
	@IBInspectable var translationKey: String? {
		get { return nil }
		set(key) {
			setTitle(key?.localized, for: .normal)
		}
   }
}

extension UITextField: SBLocalizable {
	@IBInspectable var translationKey: String? {
		get { return nil }
		set(key) {
			placeholder = key?.localized
		}
   }
}
