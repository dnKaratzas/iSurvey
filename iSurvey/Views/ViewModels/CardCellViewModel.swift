//
//  CardCellViewModel.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import Combine
import Foundation

internal class CardCellViewModel: ObservableObject {
	@DidSet var isSubmitted = false
	@DidSet var submitButtonEnabled = false
	@DidSet var loading: Bool = false
	@DidSet var error: String?
	private var questionnaire: Questionnaire
	private var subscriptions = Set<AnyCancellable>()

	var question: String {
		get {
			return questionnaire.question
		}
	}

	var answer: String {
		get {
			return questionnaire.answer
		}
		set {
			questionnaire.answer = newValue
			submitButtonEnabled = !newValue.isEmpty && !isSubmitted
		}
	}

	init(_ questionnaire: Questionnaire) {
		self.questionnaire = questionnaire

		questionnaire.$submitted
			.sink { submitted in
				self.isSubmitted = submitted
			}
			.store(in: &subscriptions)
	}

	func sendSurveyAnswer() {
		loading = true
		error = nil

		Api.sendSurveyAnswer(id: questionnaire.id, answer: questionnaire.answer)
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { [weak self] completion in
				guard let self = self else { return }

				self.loading = false

				switch completion {
					case .finished:
						break
					case .failure(let error):
						print(error.localizedDescription)
						self.error = L10n.submitAnswerError
				}
			}, receiveValue: { [weak self] _ in
				guard let self = self else { return }
				self.loading = false
				self.questionnaire.submitted = true
				self.submitButtonEnabled = false

			})
			.store(in: &subscriptions)

	}
}
