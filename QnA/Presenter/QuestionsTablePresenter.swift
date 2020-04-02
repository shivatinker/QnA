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

    enum FilterType {
        case allQuestions
        case onlyAnswered
        case onlyUnanswered
    }

    private let dataProvider: ForumDataProvider
    private weak var delegate: QuestionsTableViewDelegate?
    private var filterType = FilterType.allQuestions

    private var questionIds = [Int]()

    init() {
        self.dataProvider = DataProviderManager.getDefaultDataProvider()
    }

    public func setDelegate(_ delegate: QuestionsTableViewDelegate) {
        self.delegate = delegate
    }

    public func refresh() {
        delegate?.startLoading()
        let callback = { (mbQuestions: [Question]?, mbError: Error?) in
            guard let questions = mbQuestions else {
                self.delegate?.displayError(mbError?.localizedDescription ?? "Unknown error")
                self.delegate?.stopLoading()
                return
            }
            self.questionIds = questions.map({ $0.id })
            self.delegate?.setCellsData(questions.map({ (q) -> CellData in
                return CellData(questionText: q.question, questionAuthorName: q.asking_Name, isAnswered: q.answer != nil)
            }))
            self.delegate?.stopLoading()
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

    public func applyFilter(type: FilterType) {
        filterType = type
    }

}
