//
//  QuestionViewPresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

class QuestionViewPresenter {
	private weak var questionViewDelegate: QuestionViewDelegate?
	private let dataProvider: ForumDataProvider
	let questionId: Int

	init(questionId: Int) {
		self.questionId = questionId
		self.dataProvider = DataProviderManager.getDefaultDataProvider()
	}

	public func setDelegate(_ delegate: QuestionViewDelegate) {
		questionViewDelegate = delegate
	}

	public func refresh() {
		dataProvider.getQuestionById(questionId) { mbQuestion in
			guard let question = mbQuestion else {
				self.questionViewDelegate?.displayError("Unable to load question #\(self.questionId)")
				return
			}
			DispatchQueue.main.async {
				self.questionViewDelegate?.setQuestionText(question.question)
				self.questionViewDelegate?.setQuestionAuthorName(question.asking_Name)
				self.questionViewDelegate?.setAnswerAuthorName(question.expert_Name)
				if let answer = question.answer {
					self.questionViewDelegate?.setAnswerText(answer)
					self.questionViewDelegate?.setAnswered(true)
				} else {
					self.questionViewDelegate?.setAnswered(false)
				}
			}
		}
	}

	public func publishAnswer(text: String) {

	}
}
