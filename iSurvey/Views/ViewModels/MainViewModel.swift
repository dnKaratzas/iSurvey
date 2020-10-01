//
//  MainViewModel.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import Combine
import Foundation

internal class MainViewModel: ObservableObject {
	@DidSet var questionnaires: Questionnaires?
	@DidSet var loading: Bool = false
	@DidSet var error: String?
	private var subscriptions = Set<AnyCancellable>()

	func fetchQuestionnaires() {
		loading = true
		questionnaires = nil
		error = nil

		Api.fetchSurveyQuestions()
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { [weak self] completion in
				guard let self = self else { return }
				self.loading = false
				
				switch completion {
					case .finished:
						break
					case .failure(let error):
						print(error.localizedDescription)
						self.error = L10n.fetchSurveyError
				}
			}, receiveValue: { [weak self] surveyQuestions in
				guard let self = self else { return }

				self.loading = false
				self.questionnaires = surveyQuestions
			})
			.store(in: &subscriptions)

	}
}
