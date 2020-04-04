//
//  QuestionViewController.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    // MARK: Private members

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionAuthorNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    private var answerBlockView: AnswerBlockView!
    private var postAnswerBlockView: PostAnswerBlockView!
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()


        presenter?.delegate = self
        presenter?.errorHandler = AlertErrorHandler(parent: self)

        scrollView.alpha = 0.0

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()

        // Hack to adjust scroll area to text when user is typing
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        nc.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // Create blocks from Nibs
        answerBlockView = UINib(nibName: "AnswerBlockView", bundle: nil).instantiate(withOwner: self, options: nil).first as? AnswerBlockView
        postAnswerBlockView = UINib(nibName: "PostAnswerBlockView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PostAnswerBlockView
        postAnswerBlockView.delegate = self

        presenter?.refresh()
    }

    // Hack to adjust scroll area to text when user is typing ( copied with <3 from stackoverflow :) )
    @objc private func adjustForKeyboard(notification: Notification) {
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

    // MARK: Public API

    public var presenter: QuestionViewPresenter?

}

extension QuestionViewController: QuestionViewDelegate {
    func setData(_ data: QuestionViewData) {
        DispatchQueue.main.async {
            // TODO: Do it more clearly, maybe rework block system
            self.questionLabel.text = data.questionText
            self.questionAuthorNameLabel.text = data.questionAuthorName
            if data.isAnswered {
                self.postAnswerBlockView.isHidden = true
                self.stackView.removeArrangedSubview(self.postAnswerBlockView)

                self.answerBlockView.answerLabel.text = data.answerText
                self.answerBlockView.usernameLabel.text = data.answerAuthorName

                self.answerBlockView.isHidden = false
                self.stackView.addArrangedSubview(self.answerBlockView)
            } else {
                self.answerBlockView.isHidden = true
                self.stackView.removeArrangedSubview(self.answerBlockView)

                self.postAnswerBlockView.isHidden = false
                self.stackView.addArrangedSubview(self.postAnswerBlockView)
            }
        }
    }

    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            UIView.animate(withDuration: 0.2) {
                self.scrollView.alpha = 0.0
            }
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.2) {
                self.scrollView.alpha = 1.0
            }
        }
    }
}

extension QuestionViewController: PostAnswerBlockViewDelegate {
    func onPostAnswerClicked() {
        presenter?.postAnswer(text: postAnswerBlockView.textView.text)
    }
}
