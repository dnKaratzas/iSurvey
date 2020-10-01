//
//  Combine+DisSet.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 30/9/20.
//

import Combine
import Foundation

@propertyWrapper
internal class DidSet<Value> {
	private var val: Value
	private let subject: CurrentValueSubject<Value, Never>

	init(wrappedValue value: Value) {
		val = value
		subject = CurrentValueSubject(value)
		wrappedValue = value
	}

	var wrappedValue: Value {
		get { val }
		set {
			val = newValue
			subject.send(val)
		}
	}

	var projectedValue: CurrentValueSubject<Value, Never> {
		return subject
	}
}
