//
//  MainViewController.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 29/9/20.
//

import Combine
import GradientView
import UIKit

internal class MainViewController: UIViewController {
	@IBOutlet weak var gradientView: GradientView!
	@IBOutlet weak var startButton: LoadingButton!
	private var subscriptions = Set<AnyCancellable>()
	var viewModel: MainViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		assert(viewModel != nil)

		gradientView.colors = [Asset.background1.color, Asset.background2.color]
		setBindings()
	}

	deinit {
		print("MainViewController deinitialized")
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		if let vc = segue.destination as? QuestionnairesViewController, let questionnaires = viewModel.questionnaires {
			vc.viewModel = QuestionnairesViewModel(questionnaires: questionnaires)
		}
	}

	private func setBindings() {
		viewModel.$questionnaires
			.sink { [weak self] questionnaires in
				guard let self = self, questionnaires != nil else { return }
				self.performSegue(withIdentifier: "showQuestionnaires", sender: self)

			}
			.store(in: &subscriptions)

		viewModel.$loading
			.sink { [weak self] loading in
				guard let self = self else { return }
				if loading {
					self.startButton.showLoading()
				} else {
					self.startButton.hideLoading()
				}
			}
			.store(in: &subscriptions)

		viewModel.$error
			.sink { error in
				if let error = error {
					let banner = Banner(title: error, image: UIImage(systemName: "minus.circle"), backgroundColor: Asset.error.color)
					banner.dismissesOnTap = true
					banner.hasShadows = false
					banner.show(duration: 3.0)
				}
			}
			.store(in: &subscriptions)
	}

	@IBAction func onTapStartButton(_ sender: Any) {
		viewModel.fetchQuestionnaires()
	}
}
