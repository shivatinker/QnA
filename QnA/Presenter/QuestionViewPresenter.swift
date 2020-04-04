//
//  QuestionViewPresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

protocol QuestionViewDelegate: NSObjectProtocol {
    func setData(_ data: QuestionViewData)
    func startLoading()
    func stopLoading()
}

struct QuestionViewData {
    var questionText: String
    var questionAuthorName: String
    var answerText: String?
    var answerAuthorName: String?
    var isAnswered: Bool
}

class QuestionViewPresenter {
    // MARK: Private members
    
    private let dataProvider = DataProviderManager.getDefaultDataProvider()
    private let questionId: Int
    public var errorHandler: ErrorHandler?

    // MARK: Public API
    
    public weak var delegate: QuestionViewDelegate?
    
    init(questionId: Int) {
        self.questionId = questionId
    }
    
    public func refresh() {
        dataProvider.getQuestionById(questionId) { mbQuestion, mbError in
            self.delegate?.startLoading()
            defer { self.delegate?.stopLoading() }
            
            guard let question = mbQuestion else {
                self.errorHandler?.displayError(mbError)
                return
            }
            
            if mbError != nil {
                self.errorHandler?.displayError(mbError)
            }

            //Data binding
            self.delegate?.setData(
                QuestionViewData(questionText: question.question,
                                 questionAuthorName: question.asking_Name,
                                 answerText: question.answer,
                                 answerAuthorName: question.expert_Name,
                                 isAnswered: question.answer != nil))
        }
    }

    public func postAnswer(text: String) {
        delegate?.startLoading()
        dataProvider.postAnswer(questionId: questionId, answer: text) { (success) in
            self.refresh()
        }
    }
}
