//
//  QuestionsTablePresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

struct CellData {
	var questionText: String
	var questionAuthorName: String
	var isAnswered: Bool
}

class QuestionsTablePresenter {

	private let dataProvider: ForumDataProvider
	private weak var delegate: QuestionsTableViewDelegate?

	private var questionIds = [Int]()

	init() {
		self.dataProvider = DataProviderManager.getDefaultDataProvider()
	}

	public func setDelegate(_ delegate: QuestionsTableViewDelegate) {
		self.delegate = delegate
	}

	public func refresh() {
		dataProvider.getAllQuestionsWithAnswer { (mbQuestions, mbError) in
			guard let questions = mbQuestions else {
				self.delegate?.displayError(mbError?.localizedDescription ?? "Unknown error")
				return
			}
			self.questionIds = questions.map({ $0.id })
			self.delegate?.setCellsData(questions.map({ (q) -> CellData in
				return CellData(questionText: q.question, questionAuthorName: q.asking_Name, isAnswered: q.answer != nil)
			}))
		}
	}

	public func rowClicked(row: Int) {
		delegate?.openQuestionView(questionId: questionIds[row])
	}
}
