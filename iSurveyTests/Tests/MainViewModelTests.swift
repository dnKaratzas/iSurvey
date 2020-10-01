//
//  MainViewModelTests.swift
//  iSurveyTests
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import XCTest
@testable import iSurvey

class MainViewModelTests: XCTestCase {
	let testTimeout: TimeInterval = 2
	var mocks: Mocks!
	var customPublisher: APISessionDataPublisher!
	var viewModel: MainViewModel!

	override func setUp() {
		self.mocks = Mocks()

		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [URLProtocolMock.self]

		let session = URLSession(configuration: config)
		customPublisher = APISessionDataPublisher(session: session)

		viewModel = MainViewModel()
	}

	func testFetchQuestionnairesSuccess() {

		let url = URL(string: Api.baseURL + "/questions")
		URLProtocolMock.testURLs = [url: Data(Fixtures.surveyQuestionsResponse.utf8)]

		Api.publisher = customPublisher
		URLProtocolMock.response = mocks.validResponse

		let expectation1 = self.expectation(description: "waiting fetch questionnaires")
		let expectation2 = self.expectation(description: "waiting start loading")

		let subscription = viewModel.$questionnaires
			.sink { _ in
				guard self.viewModel.questionnaires != nil else { return }
				expectation1.fulfill()
			}
		let subscription2 = viewModel.$loading
			.sink { _ in
				guard self.viewModel.loading else { return }
				expectation2.fulfill()
			}
		
		viewModel.fetchQuestionnaires()
		wait(for: [expectation1, expectation2], timeout: testTimeout)
		subscription.cancel()
		subscription2.cancel()

		XCTAssertEqual(viewModel.questionnaires?.count, 2)
		XCTAssertNil(viewModel.error)
		XCTAssertFalse(viewModel.loading)
	}

	func testFetchQuestionnairesError() {

		let url = URL(string: Api.baseURL + "/questions")
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


		viewModel.fetchQuestionnaires()
		wait(for: [expectation1, expectation2], timeout: testTimeout)
		subscription.cancel()
		subscription2.cancel()

		XCTAssertNil(viewModel.questionnaires)
		XCTAssertNotNil(viewModel.error)
		XCTAssertEqual(viewModel.error, L10n.fetchSurveyError)
		XCTAssertFalse(viewModel.loading)
	}

}
