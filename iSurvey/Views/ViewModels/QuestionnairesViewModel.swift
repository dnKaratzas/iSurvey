//
//  QuestionnairesViewModel.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import Combine
import Foundation

internal class QuestionnairesViewModel: ObservableObject {
	@DidSet var questionnaires: Questionnaires
	@DidSet var totalSubmitted = 0
	@DidSet var cellViewModels: [CardCellViewModel] = []
	private var subscriptions = Set<AnyCancellable>()

	init(questionnaires: Questionnaires) {
		self.questionnaires = questionnaires
		self.cellViewModels = questionnaires.map {
			CardCellViewModel($0)
		}
		setBindings()
	}

	private func setBindings() {
		$questionnaires.sink { [weak self] surveyQuestions in
			guard let self = self else { return }

			for survey in surveyQuestions {
				survey.$submitted
					.sink { [weak self] _ in
						guard let self = self else { return }

						self.updateTotalSubmitted()
					}
					.store(in: &self.subscriptions)

			}
		}
		.store(in: &subscriptions)
	}

	private func updateTotalSubmitted() {
		var total = 0
		for questionnaire in questionnaires {
			if questionnaire.submitted {
				total += 1
			}
		}
		totalSubmitted = total
	}

}
