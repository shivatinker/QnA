//
//  ForumModel.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/30/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

struct Question: Codable, CustomStringConvertible {
    var description: String {
        return """
        
        Question #\(id): \(question)
        Answer: \(answer ?? "No answer")
        Asked by: #\(asked_by_id) \(asking_Name)
        Answered by: #\(expert_id) \(expert_Name)
        """
    }

    var id: Int
    var question: String

    var answer: String?
    var asked_by_id: Int
    var asking_Name: String
    var expert_id: Int
    var expert_Name: String


}

struct Expert: Codable, CustomStringConvertible {
    var description: String {
        return """
        Expert #\(id) \(name)
        """
    }

    var id: Int
    var name: String
}

