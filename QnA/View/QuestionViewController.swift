//
//  QuestionViewController.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, QuestionViewDelegate {
	func setQuestionText(_ text: String) {
		questionLabel.text = text
	}

	func setQuestionAuthorName(_ name: String) {
		questionAuthorNameLabel.text = name
	}

	func setAnswerText(_ text: String) {
		answerLabel.text = text
	}

	func setAnswerAuthorName(_ name: String) {
		answerAuthorNameLabel.text = name
	}

	func setAnswered(_ isAnswered: Bool) {

	}

	func displayError(_ text: String) {

	}

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var answerLabel: UILabel!
	@IBOutlet weak var questionAuthorNameLabel: UILabel!
	@IBOutlet weak var answerAuthorNameLabel: UILabel!

	private var presenter: QuestionViewPresenter!

	public func setPresenter(presenter: QuestionViewPresenter) {
		self.presenter = presenter
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter.setDelegate(self)
		presenter.refresh()
	}

}
