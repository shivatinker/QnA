//
//  ApiForumDataProvider.swift
//  QnA
//
//  Created by Andrii Zinoviev on 05.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

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

    private func getJSONObjectFromAPI<T: Decodable>(url: String, callback: @escaping DataGetCallback<T?>) {

        guard let url = URLComponents(string: apiURL + "/\(url)")?.url else {
            callback(nil, DataProviderError(type: .connectionError, description: "Unable to create URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { mbData, mbResponse, error in
            if let error = error {
                callback(nil, DataProviderError(type: .connectionError, description: error.localizedDescription))
                return
            }

            guard let response = mbResponse as? HTTPURLResponse else {
                callback(nil, DataProviderError(type: .connectionError, description: "Response is broken"))
                return
            }

            if response.statusCode != 200 {
                callback(nil, DataProviderError(type: .connectionError, description: "HTTP Code: \(response.statusCode)"))
                return
            }

            guard let data = mbData else {
                callback(nil, DataProviderError(type: .connectionError, description: "nil got from API"))
                return
            }

            do {
                let decoded = try JSONDecoder.init().decode(T.self, from: data)
                callback(decoded, nil)
            } catch let e {
                callback(nil, DataProviderError(type: .connectionError, description: "JSON Parsing error: \(e.localizedDescription)"))
                return
            }
        }

        dataTask.resume()
    }

    private func requestToAPI(url: String, params: [String: Any], method: String = "POST", callback: @escaping DataPostCallback) {
        guard let url = URLComponents(string: apiURL + "/\(url)")?.url else {
            callback(DataProviderError(type: .connectionError, description: "Unable to create URL"))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.queryString.data(using: .utf8)

        session.dataTask(with: request) { (mbData, mbResponse, error) in
            if let error = error {
                callback(DataProviderError(type: .connectionError, description: error.localizedDescription))
                return
            }

            guard let response = mbResponse as? HTTPURLResponse else {
                callback(DataProviderError(type: .connectionError, description: "Response is broken"))
                return
            }

            if response.statusCode != 200 {
                callback(DataProviderError(type: .connectionError, description: "HTTP Code: \(response.statusCode)"))
                return
            }

            callback(nil)
        }.resume()
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
        requestToAPI(url: "question", params: ["id": id], method: "DELETE", callback: callback)
    }
}
