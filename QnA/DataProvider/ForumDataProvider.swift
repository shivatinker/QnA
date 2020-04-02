//
//  File.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/30/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

protocol ForumDataProvider {

    //TODDO: Add error handling for all methods
    func getAllQuestionsWithAnswer(callback: @escaping ([Question]?, Error?) -> Void)
    func getAllQuestionsWithoutAnswer(callback: @escaping ([Question]?, Error?) -> Void)
    func getAllQuestions(callback: @escaping ([Question]?, Error?) -> Void)
    func getQuestionById(_ id: Int, callback: @escaping (Question?) -> Void)
    func postAnswer(questionId: Int, answer: String, callback: @escaping (Bool) -> Void)
    func askQuestion(question: String, expertId: Int, callback: @escaping (Bool) -> Void)
    func getAllExperts(callback: @escaping ([Expert]?) -> Void)
    func deleteQuestionById(_ id: Int, callback: @escaping (Bool) -> Void)
}

class DataProviderError: Error {
    var localizedDescription: String

    init(_ desc: String) {
        localizedDescription = desc
    }
}
