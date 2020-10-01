//
//  Mocks.swift
//  iSurveyTests
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import Foundation

class Mocks {
	let invalidResponse = URLResponse(url: URL(string: "http://localhost:8080")!,
									  mimeType: nil,
									  expectedContentLength: 0,
									  textEncodingName: nil)

	let validResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
										statusCode: 200,
										httpVersion: nil,
										headerFields: nil)

	let networkError = NSError(domain: "NSURLErrorDomain",
							   code: -1004, //kCFURLErrorCannotConnectToHost
							   userInfo: nil)
	
}

struct Fixtures {
	static let emptyResponse = """
	{}
	"""

	static let surveyQuestionsResponse = """
	[
	  {
		"id": 1,
		"question": "What is your favourite colour?"
	  },
	  {
		"id": 2,
		"question": "What is your favourite food?"
	  }
	]
	"""
}
