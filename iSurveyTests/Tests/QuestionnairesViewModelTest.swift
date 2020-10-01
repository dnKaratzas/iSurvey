//
//  QuestionnairesViewModelTest.swift
//  iSurveyTests
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import XCTest
@testable import iSurvey

class QuestionnairesViewModelTest: XCTestCase {
	let testTimeout: TimeInterval = 2
	var mocks: Mocks!
	var customPublisher: APISessionDataPublisher!
	var viewModel: QuestionnairesViewModel!

	override func setUp() {
		self.mocks = Mocks()

		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [URLProtocolMock.self]

		let session = URLSession(configuration: config)
		customPublisher = APISessionDataPublisher(session: session)

		let url = URL(string: Api.baseURL + "/questions")
		URLProtocolMock.testURLs = [url: Data(Fixtures.surveyQuestionsResponse.utf8)]

		Api.publisher = customPublisher
		URLProtocolMock.response = mocks.validResponse

		// Fetch questionnaires
		let mainViewModel = MainViewModel()
		let expectation1 = self.expectation(description: "waiting fetch questionnaires")
		let subscription = mainViewModel.$questionnaires
			.sink { _ in
				guard mainViewModel.questionnaires != nil else { return }
				expectation1.fulfill()
			}


		mainViewModel.fetchQuestionnaires()
		wait(for: [expectation1], timeout: testTimeout)
		subscription.cancel()

		viewModel = QuestionnairesViewModel(questionnaires: mainViewModel.questionnaires!)
	}

	func testViewModel() {
		XCTAssertEqual(viewModel.cellViewModels.count, 2)
		XCTAssertEqual(viewModel.questionnaires.count, 2)
		XCTAssertEqual(viewModel.totalSubmitted, 0)

		for i in 1...viewModel.questionnaires.count {
			viewModel.questionnaires[i - 1].submitted = true

			XCTAssertEqual(viewModel.totalSubmitted, i)
		}
	}
}
