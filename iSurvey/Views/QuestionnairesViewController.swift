//
//  QuestionnairesViewController.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import CollectionViewPagingLayout
import Combine
import GradientView
import UIKit

internal class QuestionnairesViewController: UIViewController {
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet weak var questionStateLabel: UILabel!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var previousButton: UIButton!
	@IBOutlet weak var gradientView: GradientView!
	@IBOutlet weak var submittedCountLabel: UILabel!
	private let surveyCellIdentifier = "CardViewCell"
	private var subscriptions = Set<AnyCancellable>()
	private var collectionViewLayout = CollectionViewPagingLayout()
	var viewModel: QuestionnairesViewModel?

	override func viewDidLoad() {
		super.viewDidLoad()
		assert(viewModel != nil)

		setupCollectionView()
		gradientView.colors = [Asset.background1.color, Asset.background2.color]

		setBindings()
	}

	deinit {
		print("QuestionnairesViewController deinitialized")
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	@IBAction func onPreviousTap(_ sender: Any) {
		collectionViewLayout.goToPreviousPage()
	}

	@IBAction func onNextTap(_ sender: Any) {
		collectionViewLayout.goToNextPage()
	}

	private func setBindings() {
		viewModel?.$questionnaires
			.sink { [weak self] questionnaires in
				guard let self = self, !questionnaires.isEmpty else { return }
				self.collectionView.reloadData()
				self.setQuestionStateLabel(0)
				self.collectionView?.performBatchUpdates({
					self.collectionView.collectionViewLayout.invalidateLayout()
				})
			}
			.store(in: &subscriptions)

		viewModel?.$totalSubmitted
			.sink { [weak self] totalSubmitted in
				self?.submittedCountLabel.text = String(totalSubmitted)
				if totalSubmitted == self?.viewModel?.questionnaires.count {
					self?.performSegue(withIdentifier: "showLastScreen", sender: self)
				}
			}
			.store(in: &subscriptions)
	}

	private func setupCollectionView() {
		collectionViewLayout.delegate = self

		collectionView.collectionViewLayout = collectionViewLayout
		collectionView.backgroundColor = .clear
		collectionView.register(UINib(nibName: "CardViewCell", bundle: nil), forCellWithReuseIdentifier: surveyCellIdentifier)
		collectionView.isPagingEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.dataSource = self
	}

}

// MARK: - UICollectionViewDataSource
extension QuestionnairesViewController: UICollectionViewDataSource {
	func collectionView (_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let viewModel = viewModel else { return 0 }
		return viewModel.questionnaires.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: surveyCellIdentifier, for: indexPath) as? CardViewCell else {
			fatalError("DequeueReusableCell failed while casting")
		}
		guard let viewModel = viewModel else { return cell }

		let index = indexPath.row % viewModel.questionnaires.count
		let itemViewModel = viewModel.cellViewModels[index]
		cell.viewModel = itemViewModel
		return cell
	}
}

// MARK: - CollectionViewPagingLayoutDelegate
extension QuestionnairesViewController: CollectionViewPagingLayoutDelegate {
	func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
		setNavigationButtons(currentPage)
		setQuestionStateLabel(currentPage)
	}

	private func setNavigationButtons(_ currentPage: Int) {
		guard let viewModel = viewModel else { return }

		previousButton.isEnabled = currentPage != 0
		previousButton.backgroundColor = currentPage == 0 ? .systemGray3 : .white
		previousButton.tintColor = currentPage == 0 ? .white : .black

		let isLastPage = currentPage == viewModel.questionnaires.count - 1
		nextButton.isEnabled = !isLastPage
		nextButton.backgroundColor = isLastPage ? .systemGray3 : Asset.accentColor.color
	}

	private func setQuestionStateLabel(_ currentPage: Int) {
		guard let viewModel = viewModel else { return }
		let text = "\(currentPage + 1)/\(viewModel.questionnaires.count)"
		let attributedString = NSMutableAttributedString(string: "\(currentPage + 1)/\(viewModel.questionnaires.count)")

		let range: Range<String.Index> = text.range(of: "/")!
		let index0: Int = text.distance(from: text.startIndex, to: range.upperBound)
		let index1: Int = text.distance(from: range.upperBound, to: text.endIndex)

		let attributes0: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: 24.0)
		]

		attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: index0))

		let attributes1: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: 17.0)
		]
		attributedString.addAttributes(attributes1, range: NSRange(location: index0, length: index1))

		questionStateLabel.attributedText = attributedString
	}
}
