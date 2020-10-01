//
//  Api.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import Combine
import Foundation

internal enum APIError: Error {
	case serverError
	case noSurveyQuestions
	case unknown, apiError(reason: String)

	var errorDescription: String? {
		switch self {
			case .unknown, .noSurveyQuestions, .serverError:
				return "Unknown error"
			case .apiError(let reason):
				return reason
		}
	}
}

internal struct Api {
	static let baseURL = "https://powerful-peak-54206.herokuapp.com"

	static let defaultHeaders = [
		"Content-Type": "application/json",
		"cache-control": "no-cache"
	]

	static var publisher: APIDataTaskPublisher = APISessionDataPublisher()

	private static func buildGetSurveyQuestionsRequest() -> URLRequest {
		guard let url = URL(string: "\(baseURL)/questions" ) else {
			fatalError("APIError.invalidEndpoint")
		}
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = defaultHeaders
		return request
	}

	static func getSurveyQuestionsDTP() -> URLSession.DataTaskPublisher {
		let request = buildGetSurveyQuestionsRequest()
		return publisher.dataTaskPublisher(for: request)
	}

	private static func buildSendSurveyAnswerRequest(id: Int, answer: String) -> URLRequest {
		guard let url = URL(string: "\(baseURL)/question/submit" ) else {
			fatalError("APIError.invalidEndpoint")
		}
		var request = URLRequest(url: url)
		let parameters: [String: Any] = [
			"id": id,
			"answer": answer
		]

		request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = defaultHeaders
		return request
	}

	internal static func postSendSurveyAnswerDTP(id: Int, answer: String) -> URLSession.DataTaskPublisher {
		let request = buildSendSurveyAnswerRequest(id: id, answer: answer)
		return publisher.dataTaskPublisher(for: request)
	}

	static func fetchSurveyQuestions() -> AnyPublisher<Questionnaires, APIError> {
		return getSurveyQuestionsDTP()
			.tryMap { data, response in
				guard let httpResponse = response as? HTTPURLResponse, 200 == httpResponse.statusCode else {
					throw APIError.unknown
				}
				if let surveyQuestions = try? JSONDecoder().decode(Questionnaires.self, from: data), !surveyQuestions.isEmpty {
					return surveyQuestions
				} else {
					throw APIError.noSurveyQuestions
				}
			}
			.mapError { error in
				if let error = error as? APIError {
					return error
				} else {
					return APIError.apiError(reason: error.localizedDescription)
				}
			}
			.eraseToAnyPublisher()
	}

	static func sendSurveyAnswer(id: Int, answer: String) -> AnyPublisher<Void, APIError> {
		return postSendSurveyAnswerDTP(id: id, answer: answer)
			.tryMap { _, response in
				guard let httpResponse = response as? HTTPURLResponse, 200 == httpResponse.statusCode else {
					throw APIError.unknown
				}
				return
			}
			.mapError { error in
				if let error = error as? APIError {
					return error
				} else {
					return APIError.apiError(reason: error.localizedDescription)
				}
			}
			.eraseToAnyPublisher()
	}

}
