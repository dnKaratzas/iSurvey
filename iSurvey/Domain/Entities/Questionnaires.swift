//
//  SurveyQuestions.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import Combine
import Foundation

// MARK: - SurveyQuestion
internal class Questionnaire: Codable, ObservableObject {
	@DidSet var submitted = false
	let id: Int
	let question: String
	var answer = ""

	init(id: Int, question: String, answer: String) {
		self.id = id
		self.question = question
		self.answer = answer
	}

	private enum CodingKeys: String, CodingKey {
		case id, question
	}
}

internal typealias Questionnaires = [Questionnaire]
