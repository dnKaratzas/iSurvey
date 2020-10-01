//
//  UIView++.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import UIKit

extension UIView {
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
			self.layer.masksToBounds = true
		}
	}

	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable var borderColor: UIColor? {
		get {
			if let color = layer.borderColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.borderColor = color.cgColor
			} else {
				layer.borderColor = nil
			}
		}
	}
}
