//
//  CardCellViewModelTest.swift
//  iSurveyTests
//
//  Created by Dionisis Karatzas on 1/10/20.
//


import XCTest
@testable import iSurvey

class CardCellViewModelTest: XCTestCase {
	let testTimeout: TimeInterval = 2
	var mocks: Mocks!
	var customPublisher: APISessionDataPublisher!
	var viewModel: CardCellViewModel!

	override func setUp() {
		self.mocks = Mocks()

		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [URLProtocolMock.self]

		let session = URLSession(configuration: config)
		customPublisher = APISessionDataPublisher(session: session)

		viewModel = CardCellViewModel(Questionnaire(id: 1, question: "question", answer: "answer"))
		viewModel.answer = "answer"
	}

	func testSendSurveyAnswerSuccess() {
		let url = URL(string: Api.baseURL + "/question/submit")
		URLProtocolMock.testURLs = [url: Data(Fixtures.surveyQuestionsResponse.utf8)]

		Api.publisher = customPublisher
		URLProtocolMock.response = mocks.validResponse

		let expectation1 = self.expectation(description: "waiting fetch questionnaires")
		let expectation2 = self.expectation(description: "waiting start loading")

		let subscription = viewModel.$isSubmitted
			.sink { _ in
				guard self.viewModel.isSubmitted else { return }
				expectation1.fulfill()
			}
		let subscription2 = viewModel.$loading
			.sink { _ in
				guard self.viewModel.loading else { return }
				expectation2.fulfill()
			}

		viewModel.sendSurveyAnswer()
		wait(for: [expectation1, expectation2], timeout: testTimeout)
		subscription.cancel()
		subscription2.cancel()

		XCTAssertTrue(viewModel.isSubmitted)
		XCTAssertFalse(viewModel.submitButtonEnabled)
		XCTAssertNil(viewModel.error)
		XCTAssertFalse(viewModel.loading)
	}

	func testSendSurveyAnswerError() {
		let url = URL(string: Api.baseURL + "/question/submit")
		URLProtocolMock.testURLs = [url: Data(Fixtures.surveyQuestionsResponse.utf8)]

		Api.publisher = customPublisher
		URLProtocolMock.response = mocks.invalidResponse

		let expectation1 = self.expectation(description: "waiting error")
		let expectation2 = self.expectation(description: "waiting start loading")

		let subscription = viewModel.$error
			.sink { _ in
				guard self.viewModel.error != nil else { return }
				expectation1.fulfill()
			}
		let subscription2 = viewModel.$loading
			.sink { _ in
				guard self.viewModel.loading else { return }
				expectation2.fulfill()
			}

		viewModel.sendSurveyAnswer()
		wait(for: [expectation1, expectation2], timeout: testTimeout)
		subscription.cancel()
		subscription2.cancel()

		XCTAssertFalse(viewModel.isSubmitted)
		XCTAssertTrue(viewModel.submitButtonEnabled)
		XCTAssertNotNil(viewModel.error)
		XCTAssertEqual(viewModel.error, L10n.submitAnswerError)
		XCTAssertFalse(viewModel.loading)
	}
}
