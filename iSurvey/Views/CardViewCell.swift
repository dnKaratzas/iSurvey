//
//  CardViewCell.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import Combine
import UIKit
import CollectionViewPagingLayout

internal class CardViewCell: UICollectionViewCell, ScaleTransformView {
	@IBOutlet private weak var backgroundContainerView: UIView!
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var submitButton: LoadingButton!
	@IBOutlet weak var answerTextField: UITextField!
	private var subscriptions = Set<AnyCancellable>()

	var viewModel: CardCellViewModel? {
		didSet {
			updateViews()
			setBindings()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		setupViews()
	}

	private func setBindings() {
		viewModel?.$isSubmitted
			.sink { [weak self] isSubmitted in
				guard let self = self else { return }

				self.setSubmitButtonState(enabled: self.viewModel?.submitButtonEnabled ?? false)
				self.submitButton.setTitle(isSubmitted ? L10n.alreadySubmitted : L10n.submit, for: .normal)
				self.answerTextField.isEnabled = !isSubmitted

				if isSubmitted {
					let banner = Banner(title: L10n.answerSubmitted, image: UIImage(systemName: "checkmark.circle"), backgroundColor: UIColor.systemGreen)
					banner.dismissesOnTap = true
					banner.hasShadows = false
					banner.show(duration: 3.0)
				}
			}
			.store(in: &subscriptions)

		viewModel?.$submitButtonEnabled
			.sink { [weak self] isEnabled in
				guard let self = self else { return }

				self.setSubmitButtonState(enabled: isEnabled)
			}
			.store(in: &subscriptions)

		viewModel?.$loading
			.sink { [weak self] loading in
				guard let self = self else { return }
				if loading {
					self.submitButton.showLoading()
				} else {
					self.submitButton.hideLoading()
				}
			}
			.store(in: &subscriptions)

		viewModel?.$error
			.sink { [weak self] error in
				guard let self = self, let error = error else { return }
				self.submitButton.setTitle(L10n.retrySubmit, for: .normal)

				let banner = Banner(title: error, image: UIImage(systemName: "minus.circle"), backgroundColor: Asset.error.color)
				banner.dismissesOnTap = true
				banner.hasShadows = false
				banner.show(duration: 3.0)
			}
			.store(in: &subscriptions)
	}

	@IBAction func onSubmitTap(_ sender: Any) {
		guard let viewModel = viewModel else { return }
		viewModel.sendSurveyAnswer()
	}

	@IBAction func answerTextfieldTextChanged(_ sender: Any) {
		viewModel?.answer = answerTextField.text ?? ""
	}

	private func setupViews() {
		clipsToBounds = false
		contentView.clipsToBounds = false
		backgroundColor = .clear

		backgroundContainerView.backgroundColor = .white
		backgroundContainerView.layer.cornerRadius = 20
		backgroundContainerView.layer.shadowColor = UIColor.black.cgColor
		backgroundContainerView.layer.shadowOpacity = 0.6
		backgroundContainerView.layer.shadowOffset = .init(width: 0, height: 2)
		backgroundContainerView.layer.shadowRadius = 10
	}

	private func updateViews() {
		guard let viewModel = viewModel else { return }
		questionLabel.text = viewModel.question
	}

	private func setSubmitButtonState(enabled: Bool) {
		self.submitButton.isUserInteractionEnabled = enabled
		self.submitButton.backgroundColor = enabled ? Asset.accentColor.color :.systemGray3
	}

	var scaleOptions = ScaleTransformViewOptions(
		minScale: 0.60,
		maxScale: 1.00,
		scaleRatio: 0.40,
		translationRatio: .init(x: 0.66, y: 0.20),
		minTranslationRatio: .init(x: -5.00, y: -5.00),
		maxTranslationRatio: .init(x: 5.00, y: 5.00),
		keepVerticalSpacingEqual: true,
		keepHorizontalSpacingEqual: true,
		scaleCurve: .easeIn,
		translationCurve: .linear,
		shadowEnabled: true,
		shadowColor: .black,
		shadowOpacity: 0.60,
		shadowRadiusMin: 2.00,
		shadowRadiusMax: 13.00,
		shadowOffsetMin: .init(width: 0.00, height: 2.00),
		shadowOffsetMax: .init(width: 0.00, height: 6.00),
		shadowOpacityMin: 0.10,
		shadowOpacityMax: 0.10,
		blurEffectEnabled: false,
		blurEffectRadiusRatio: 0.40,
		blurEffectStyle: .light,
		rotation3d: nil,
		translation3d: nil
	)
}
