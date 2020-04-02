//
//  QuestionViewController.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

protocol PostAnswerBlockDelegate: NSObjectProtocol {
    func postAnswer()
}

class QuestionViewController: UIViewController, QuestionViewDelegate, PostAnswerBlockDelegate {
    func postAnswer() {
        presenter.publishAnswer(text: postAnswerBlockView.textView.text)
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionAuthorNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    func startLoading() {
        self.scrollView.alpha = 0.0
    }

    func stopLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 1.0
        })
    }

    //TODO: Add data passing with single object
    func setQuestionText(_ text: String) {
        questionLabel.text = text
    }

    func setQuestionAuthorName(_ name: String) {
        questionAuthorNameLabel.text = name
    }

    var answerView: AnswerBlockView!
    var postAnswerBlockView: PostAnswerView!

    func setAnswerText(_ text: String) {
        answerView.answerLabel.text = text
    }

    func setAnswerAuthorName(_ name: String) {
        answerView.usernameLabel.text = name

    }

    func setAnswered(_ isAnswered: Bool) {
        if isAnswered {
            stackView.addArrangedSubview(answerView)
            postAnswerBlockView.isHidden = true
            answerView.isHidden = false
        } else {
            stackView.addArrangedSubview(postAnswerBlockView)
            answerView.isHidden = true
            postAnswerBlockView.isHidden = false
        }
    }

    func displayError(_ text: String) {
        //FIXME: display error
    }

    private var presenter: QuestionViewPresenter!

    public func setPresenter(presenter: QuestionViewPresenter) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        nc.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        answerView = UINib(nibName: "AnswerBlockView", bundle: nil).instantiate(withOwner: self, options: nil).first as? AnswerBlockView
        postAnswerBlockView = UINib(nibName: "PostAnswerBlockView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PostAnswerView
        postAnswerBlockView.setDelegate(delegate: self)

        presenter.setDelegate(self)
        presenter.refresh()
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

    }
}
