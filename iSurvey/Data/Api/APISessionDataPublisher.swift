//
//  APISessionDataPublisher.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 1/10/20.
//

import Foundation

internal protocol APIDataTaskPublisher {
	func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

internal class APISessionDataPublisher: APIDataTaskPublisher {

	func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
		return session.dataTaskPublisher(for: request)
	}

	var session: URLSession

	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
}
