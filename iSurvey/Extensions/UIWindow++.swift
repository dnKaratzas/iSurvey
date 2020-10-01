//
//  UIWindow++.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import UIKit

import UIKit

public extension UIWindow {
	static var keyWindow: UIWindow? {
		return UIApplication.shared.windows.first { $0.isKeyWindow }
	}
}
