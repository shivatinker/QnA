//
//  QuestionViewPresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

class QuestionViewPresenter {
    private weak var delegate: QuestionViewDelegate?
    private let dataProvider: ForumDataProvider
    let questionId: Int

    init(questionId: Int) {
        self.questionId = questionId
        self.dataProvider = DataProviderManager.getDefaultDataProvider()
    }

    public func setDelegate(_ delegate: QuestionViewDelegate) {
        self.delegate = delegate
    }

    public func refresh() {
        delegate?.startLoading()
        dataProvider.getQuestionById(questionId) { mbQuestion in
            guard let question = mbQuestion else {
                DispatchQueue.main.async {
                    self.delegate?.displayError("Unable to load question #\(self.questionId)")
                    self.delegate?.stopLoading()
                }
                return
            }
            DispatchQueue.main.async {
                self.delegate?.setQuestionText(question.question)
                self.delegate?.setQuestionAuthorName(question.asking_Name)
                self.delegate?.setAnswerAuthorName(question.expert_Name)
                if let answer = question.answer {
                    self.delegate?.setAnswerText(answer)
                    self.delegate?.setAnswered(true)
                } else {
                    self.delegate?.setAnswered(false)
                }
                self.delegate?.stopLoading()
            }
        }
    }

    public func publishAnswer(text: String) {
        delegate?.startLoading()
        dataProvider.postAnswer(questionId: questionId, answer: text) { (success) in
            DispatchQueue.main.async {
                self.refresh()
            }
        }
    }
}
