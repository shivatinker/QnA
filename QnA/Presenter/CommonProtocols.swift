//
//  CommonProtocols.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

protocol ErrorHandler: NSObjectProtocol {
	func displayError(_ text: String)
}

protocol QuestionViewDelegate: ErrorHandler {
	func setQuestionText(_ text: String)
	func setQuestionAuthorName(_ name: String)
	func setAnswerText(_ text: String)
	func setAnswerAuthorName(_ name: String)
	func setAnswered(_ isAnswered: Bool)
}

protocol QuestionsTableViewDelegate: ErrorHandler {
	func setCellsData(_ data: [CellData])
	func clear()
	func openQuestionView(questionId: Int) //TODO: Create router class to perform navigation and assembly
}
