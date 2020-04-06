//
//  ApiForumDataProvider.swift
//  QnA
//
//  Created by Andrii Zinoviev on 05.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import Alamofire

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key, value) in self {
            output += "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}

class ApiForumDataProvider: ForumDataProvider {
    private let apiURL = "https://sinspython.herokuapp.com"
    private let session = URLSession(configuration: .default)
    private let userId = 1
    private var username = "%UNKNOWN%"

    init() {
        getAllExperts { (experts, error) in
            self.username = experts?.filter({ $0.id == self.userId }).first?.name ?? "%UNKNOWN%"
        }
    }

    private static func checkResponse<T: Decodable>(dataResponse: AFDataResponse<T>) -> DataProviderError? {
        if let error = dataResponse.error {
            return DataProviderError(type: .connectionError, description: error.localizedDescription)
        }
        guard let response = dataResponse.response else {
            return DataProviderError(type: .connectionError, description: "Response is nil")
        }

        if !(200..<300 ~= response.statusCode) {
            return DataProviderError(type: .connectionError, description: "HTTP \(response.statusCode) got")
        }
        return nil
    }

    private func getJSONObjectFromAPI<T: Decodable>(url: String, callback: @escaping DataGetCallback<T?>) {
        AF.request(apiURL + "/\(url)").responseDecodable(
            of: T.self,
            queue: DispatchQueue.global(qos: .userInitiated))
        { dataResponse in
            if let error = ApiForumDataProvider.checkResponse(dataResponse: dataResponse) {
                callback(nil, error)
            }

            do {
                try callback(dataResponse.result.get(), nil)
            } catch let e {
                callback(nil, DataProviderError(type: .connectionError, description: e.localizedDescription))
            }
        }
    }

    private static let commonHeaders: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    private func requestToAPI(url: String, params: [String: Any], method: HTTPMethod = .post, callback: @escaping DataPostCallback) {
        AF.request(
            apiURL + "/\(url)",
            method: method,
            parameters: params,
            encoding: URLEncoding.httpBody,
            headers: ApiForumDataProvider.commonHeaders
        ).response { (dataResponse) in
            callback(ApiForumDataProvider.checkResponse(dataResponse: dataResponse))
        }
    }

    func getUsername() -> String {
        return username
    }

    func getAllQuestionsWithAnswer(callback: @escaping DataGetCallback<[Question]?>) {
        getJSONObjectFromAPI(url: "allQuestion", callback: callback)
    }

    func getAllQuestionsWithoutAnswer(callback: @escaping DataGetCallback<[Question]?>) {
        getJSONObjectFromAPI(url: "allQuestionNoAnswer", callback: callback)
    }

    var questionsBuffer: [Question]?
    var mbError: DataProviderError?
    let group = DispatchGroup()
    func getAllQuestions(callback: @escaping DataGetCallback<[Question]?>) {
        questionsBuffer = []
        let partial: DataGetCallback<[Question]?> = { (mbQuestions, mbError) in
            if let error = mbError {
                self.mbError = error
            }
            if let questions = mbQuestions {
                self.questionsBuffer?.append(contentsOf: questions)
            }
            self.group.leave()
        }

        group.enter()
        getAllQuestionsWithAnswer(callback: partial)
        group.enter()
        getAllQuestionsWithoutAnswer(callback: partial)

        group.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            callback(self.questionsBuffer?.sorted(by: { !($0.answer == nil) || ($1.answer == nil) }), self.mbError)
        }
    }

    func getQuestionById(_ id: Int, callback: @escaping DataGetCallback<Question?>) {
        getJSONObjectFromAPI(url: "oneQuestion/\(id)", callback: callback)
    }

    func getAllExperts(callback: @escaping DataGetCallback<[Expert]?>) {
        getJSONObjectFromAPI(url: "allExpert", callback: callback)
    }

    func postAnswer(questionId: Int, answer: String, callback: @escaping DataPostCallback) {
        requestToAPI(url: "sendAnswer", params: ["answer": answer, "id": questionId], callback: callback)
    }

    func askQuestion(question: String, expertId: Int, callback: @escaping DataPostCallback) {
        requestToAPI(url: "newQuestion", params: ["question": question, "expert": expertId], callback: callback)
    }

    func deleteQuestionById(_ id: Int, callback: @escaping DataPostCallback) {
        requestToAPI(url: "question", params: ["id": id], method: .delete, callback: callback)
    }
}
