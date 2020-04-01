//
//  MockForumDataProvider.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/30/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

class MockForumDataProvider: ForumDataProvider {

	let userId = 42
	let userName = "Andrii Test"

	var questions: [Question]?
	var experts: [Expert]?

	init(questionsJson: Data, expertsJson: Data) throws {
		let decoder = JSONDecoder.init()
		questions = try decoder.decode([Question].self, from: questionsJson)
		experts = try decoder.decode([Expert].self, from: expertsJson)
	}

	func getAllQuestionsWithAnswer(callback: @escaping ([Question]?, Error?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			guard let q = self.questions else {
				callback(nil, DataProviderError("Unable to read JSON"))
				return
			}
			callback(q.filter({ $0.answer != nil }), nil)
		}
	}

	func getAllQuestionsWithoutAnswer(callback: @escaping ([Question]?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			callback(self.questions?.filter({ $0.answer == nil }))
		}
	}

	func getQuestionById(_ id: Int, callback: @escaping (Question?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			callback(self.questions?.first(where: { $0.id == id }))
		}
	}

	func postAnswer(questionId: Int, answer: String, callback: @escaping (Bool) -> Void) {
		//FIXME: Fix
		DispatchQueue.global(qos: .userInitiated).async {
			guard let v = self.questions?.first(where: { $0.id == questionId }) else {
				callback(false)
				return
			}
			//v.answer = answer
			callback(true)
		}
	}

	private func getNextQuestionId() -> Int {
		return questions?.map({ $0.id }).max() ?? 0
	}

	func askQuestion(question: String, expertId: Int, callback: @escaping (Bool) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			guard let e = self.experts?.first(where: { $0.id == expertId }) else {
				callback(false)
				return
			}
			self.questions?.append(
				Question(id: self.getNextQuestionId(),
					question: question,
					answer: nil,
					asked_by_id: self.userId,
					asking_Name: self.userName,
					expert_id: e.id,
					expert_Name: e.name))
			callback(true)
		}
	}

	func getAllExperts(callback: @escaping ([Expert]?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			callback(self.experts)
		}
	}

	func deleteQuestionById(_ id: Int, callback: (Bool) -> Void) {
		guard self.questions?.first(where: { $0.id == id }) != nil else {
			callback(false)
			return
		}
		self.questions?.removeAll(where: { $0.id == id })
		callback(true)
	}

}
