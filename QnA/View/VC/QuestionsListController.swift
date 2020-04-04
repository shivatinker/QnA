//
//  ViewController.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/30/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

class QuestionsListViewController: UIViewController {


    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var askButton: UIBarButtonItem!
    @IBOutlet weak var tableView: QuestionsTableView!

    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    public var presenter: QuestionsListViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Use router for assembling
        presenter = QuestionsListViewPresenter()
        presenter?.delegate = self
        presenter?.errorHandler = AlertErrorHandler(parent: self)

        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: activityIndicator))
        tableView.superviewDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter?.refresh()
    }

    @IBAction func onFilterClicked() {
        let fc = FilterChooser(parent: self)
        fc.show() { filter in
            self.presenter?.filterType = filter
            self.presenter?.refresh()
        }
    }


}

extension QuestionsListViewController: QuestionsTableDelegate {
    func onRowClicked(row: Int, cell: QuestionsTableViewCellData) {
        presenter?.rowClicked(row: row)
    }
}

extension QuestionsListViewController: QuestionsListDelegate {
    func setDisplayedQuestions(_ questions: [QuestionData]) {
        DispatchQueue.main.async {
            // Data binding
            self.tableView.setCells(questions.map({
                QuestionsTableViewCellData(questionText: $0.questionText,
                                           questionAuthorName: $0.questionAuthorName,
                                           isAnswered: $0.isAnswered) }))
        }
    }

    func clearTable() {
        DispatchQueue.main.async {
            self.tableView.clear()
        }
    }

    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func openQuestionView(questionId: Int) {
        // TODO: Use router for this sh*t
        let vc = UIStoryboard(name: "QuestionView", bundle: nil).instantiateViewController(identifier: "QuestionViewController") as! QuestionViewController
        vc.presenter = QuestionViewPresenter(questionId: questionId)
        MyNavigationController.instance.show(vc, sender: nil)
    }
}
