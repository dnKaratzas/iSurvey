//
//  FinishViewController.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import GradientView
import UIKit

internal class FinishViewController: UIViewController {
	@IBOutlet weak var gradientView: GradientView!
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		gradientView.colors = [Asset.background1.color, Asset.background2.color]
	}

	@IBAction func onFinishButton(_ sender: Any) {
		exit(0)
	}
}
