//
//  CircleButton.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import UIKit

@IBDesignable public class CircleButton: UIButton {
	public override func didMoveToSuperview() {
		super.didMoveToSuperview()
		layer.cornerRadius = frame.size.width / 2
		clipsToBounds = true
	}

	public override func didMoveToWindow() {
		super.didMoveToWindow()
		layer.cornerRadius = frame.size.width / 2
		clipsToBounds = true
	}
}
