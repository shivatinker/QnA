//
//  File.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/30/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

typealias DataGetCallback<T> = (T, DataProviderError?) -> Void
typealias DataPostCallback = (DataProviderError?) -> Void

protocol ForumDataProvider {
    
    // MARK: Info queries
    func getUsername() -> String
    // MARK: Get queries
    func getAllQuestionsWithAnswer(callback: @escaping DataGetCallback<[Question]?>)
    func getAllQuestionsWithoutAnswer(callback: @escaping DataGetCallback<[Question]?>)
    func getAllQuestions(callback: @escaping DataGetCallback<[Question]?>)
    func getQuestionById(_ id: Int, callback: @escaping DataGetCallback<Question?>)
    func getAllExperts(callback: @escaping DataGetCallback<[Expert]?>)

    // MARK: Post queries
    func postAnswer(questionId: Int, answer: String, callback: @escaping DataPostCallback)
    func askQuestion(question: String, expertId: Int, callback: @escaping DataPostCallback)
    func deleteQuestionById(_ id: Int, callback: @escaping DataPostCallback)

}

struct DataProviderError: Error {

    enum ErrorType {
        case noSuchQuestion
        case noSuchExpert
        case unknown
    }

    var type: ErrorType
    var description: String
}

extension DataProviderError: LocalizedError {
    public var errorDescription: String? {
        switch type {
        case .noSuchExpert: return "No such expert\n" + description
        case .noSuchQuestion: return "No such question\n" + description
        case .unknown: return "We don't know what happened(\n" + description
        }
    }
}
