//
//  ApiTests.swift
//  iSurveyTests
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import XCTest
import Foundation
import Combine
@testable import iSurvey

class ApiTests: XCTestCase {
	let testTimeout: TimeInterval = 2

	var mocks: Mocks!
	var customPublisher: APISessionDataPublisher!

	override func setUp() {
		self.mocks = Mocks()

		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [URLProtocolMock.self]

		let session = URLSession(configuration: config)
		customPublisher = APISessionDataPublisher(session: session)
	}

	override func tearDown() {
		self.mocks = nil

		//Restore the default publisher
		Api.publisher = APISessionDataPublisher()

		URLProtocolMock.response = nil
		URLProtocolMock.error = nil
		URLProtocolMock.testURLs = [URL?: Data]()
	}

	func testBaseURL() {
		XCTAssertEqual(Api.baseURL, "https://powerful-peak-54206.herokuapp.com")
	}

	func testDefaultHeaders() {
		XCTAssertEqual(Api.defaultHeaders["Content-Type"], "application/json")
		XCTAssertEqual(Api.defaultHeaders["cache-control"], "no-cache")
		XCTAssertEqual(Api.defaultHeaders.count, 2)
	}

	func testGetSurveyQuestionsDTP() {
		let future = Api.getSurveyQuestionsDTP()
		let request =  future.request
		XCTAssertEqual(request.url?.absoluteString, Api.baseURL + "/questions")
		XCTAssertEqual(request.httpMethod, "GET")
		XCTAssertEqual(request.allHTTPHeaderFields?.count, Api.defaultHeaders.count)
		XCTAssertNil(request.httpBody)
	}

	func testPostSendSurveyAnswerDTP() {
		let future = Api.postSendSurveyAnswerDTP(id: 1, answer: "Test Answer")
		let request =  future.request
		XCTAssertEqual(request.url?.absoluteString, Api.baseURL + "/question/submit")
		XCTAssertEqual(request.httpMethod, "POST")
		XCTAssertEqual(request.allHTTPHeaderFields?.count, Api.defaultHeaders.count)
		XCTAssertNotNil(request.httpBody)
	}

	func testGetSurveyQuestions() {
		//Setup fixture
		let url = URL(string: Api.baseURL + "/questions")
		URLProtocolMock.testURLs = [url: Data(Fixtures.surveyQuestionsResponse.utf8)]

		// When is valid
		Api.publisher = customPublisher
		URLProtocolMock.response = mocks.validResponse
		let publisher = Api.fetchSurveyQuestions()

		let validTest = evalValidResponseTest(publisher: publisher)
		wait(for: validTest.expectations, timeout: testTimeout)
		validTest.cancellable?.cancel()

		// 2) When has invalid response
		URLProtocolMock.response = mocks.invalidResponse
		let publisher2 = Api.fetchSurveyQuestions()
		let invalidTest = evalInvalidResponseTest(publisher: publisher2)
		wait(for: invalidTest.expectations, timeout: testTimeout)
		invalidTest.cancellable?.cancel()

		// 3) Network Failure
		URLProtocolMock.response = mocks.validResponse
		URLProtocolMock.error = mocks.networkError

		let publisher4 = Api.fetchSurveyQuestions()
		let invalidTest4 = evalInvalidResponseTest(publisher: publisher4)
		wait(for: invalidTest4.expectations, timeout: testTimeout)
		invalidTest4.cancellable?.cancel()
	}

	func testSendSurveyAnswer() {
		// Setup fixture
		let url = URL(string: Api.baseURL + "/question/submit")
		URLProtocolMock.testURLs = [url: Data(Fixtures.emptyResponse.utf8)]

		// 1) When is valid
		Api.publisher = customPublisher
		URLProtocolMock.response = mocks.validResponse
		let publisher = Api.sendSurveyAnswer(id: 1, answer: "answer")

		let validTest = evalValidResponseTest(publisher: publisher)
		wait(for: validTest.expectations, timeout: testTimeout)
		validTest.cancellable?.cancel()

		// 2) When has invalid response
		URLProtocolMock.response = mocks.invalidResponse
		let publisher2 = Api.sendSurveyAnswer(id: 1, answer: "answer")
		let invalidTest = evalInvalidResponseTest(publisher: publisher2)
		wait(for: invalidTest.expectations, timeout: testTimeout)
		invalidTest.cancellable?.cancel()

		// 3) Network Failure
		URLProtocolMock.response = mocks.validResponse
		URLProtocolMock.error = mocks.networkError

		let publisher4 = Api.sendSurveyAnswer(id: 1, answer: "answer")
		let invalidTest4 = evalInvalidResponseTest(publisher: publisher4)
		wait(for: invalidTest4.expectations, timeout: testTimeout)
		invalidTest4.cancellable?.cancel()
	}
}
