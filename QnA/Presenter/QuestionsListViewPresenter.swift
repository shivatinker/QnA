//
//  QuestionsTablePresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation



protocol QuestionsListDelegate: NSObjectProtocol {
    func setDisplayedQuestions(_ questions: [QuestionData], silent: Bool)
    func clearTable()
    func openQuestionView(questionId: Int) //TODO: Create router class to perform navigation and assembly
    func openAskView() //TODO: Create router class to perform navigation and assembly
    func startLoading()
    func stopLoading()
}

struct QuestionData {
    var questionText: String
    var questionAuthorName: String
    var isAnswered: Bool
}

/**
 #Presenter for question list view
 */
class QuestionsListViewPresenter {

    // MARK: Private
    private let dataProvider = DataProviderManager.getDefaultDataProvider()
    private var questionIds = [Int]()

    // MARK: Public API

    enum FilterType {
        case allQuestions
        case onlyAnswered
        case onlyUnanswered
    }

    public var filterType = FilterType.allQuestions
    public var errorHandler: ErrorHandler?
    public weak var delegate: QuestionsListDelegate?

    public func refresh(silent: Bool = false) {
        self.delegate?.startLoading()
        //self.delegate?.clearTable()
        let callback = { (mbQuestions: [Question]?, mbError: Error?) in
            defer { self.delegate?.stopLoading() }
            guard let questions = mbQuestions else {
                self.errorHandler?.displayError(mbError)
                return
            }
            self.questionIds = questions.map({ $0.id })
            // Data binding
            self.delegate?.setDisplayedQuestions(questions.map({ (q) -> QuestionData in
                return QuestionData(questionText: q.question, questionAuthorName: q.asking_Name, isAnswered: q.answer != nil)
            }), silent: silent)
        }
        switch filterType {
        case .allQuestions: dataProvider.getAllQuestions(callback: callback)
        case .onlyAnswered: dataProvider.getAllQuestionsWithAnswer(callback: callback)
        case .onlyUnanswered: dataProvider.getAllQuestionsWithoutAnswer(callback: callback)
        }
    }

    public func rowClicked(row: Int) {
        delegate?.openQuestionView(questionId: questionIds[row])
    }

    public func askClicked() {
        delegate?.openAskView()
    }

    public func rowDeleteRequested(row: Int) {
        delegate?.startLoading()
        dataProvider.deleteQuestionById(questionIds[row]) { mbError in
            defer {
                self.delegate?.stopLoading()
            }
            if let error = mbError {
                self.errorHandler?.displayError(error)
                self.refresh()
                return
            }
        }
    }
}
