//
//  QuestionsTableView.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

protocol QuestionsTableDelegate: ErrorHandler {
    func startLoading()
    func stopLoading()
}

class QuestionsTableView: UITableView, UITableViewDelegate, UITableViewDataSource, QuestionsTableViewDelegate {
    func startLoading() {
        DispatchQueue.main.async {
            self.superviewDelegate?.startLoading()
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.superviewDelegate?.stopLoading()
        }
    }


    private let cell_id = "abcd"
    private var cellsData = [CellData]()
    private var presenter: QuestionsTablePresenter!
    private weak var superviewDelegate: QuestionsTableDelegate?



    func setDelegate(delegate: QuestionsTableDelegate) {
        superviewDelegate = delegate
    }

    func setCellsData(_ data: [CellData]) {
        clear()
        DispatchQueue.main.async {
            self.performBatchUpdates({
                self.cellsData = data
                for i in 0..<data.count {
                    self.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                }
            }, completion: nil)
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.performBatchUpdates({
                let indices = Array(0..<self.cellsData.count).map({ IndexPath(row: $0, section: 0) })
                self.deleteRows(at: indices, with: .automatic)
                self.cellsData.removeAll()
            }, completion: nil)
        }
    }

    //Error propagating to parent view
    func displayError(_ text: String) {
        superviewDelegate?.displayError(text)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = cellsData[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: cell_id) as! QuestionTableViewCell
        cell.answeredView.isHidden = !data.isAnswered
        cell.usernameLabel.text = data.questionAuthorName
        cell.questionTextLabel.text = data.questionText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        presenter.rowClicked(row: indexPath.row)
    }

    private func prepare() {
        delegate = self
        dataSource = self
        register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: cell_id)
        presenter = QuestionsTablePresenter()
        presenter.setDelegate(self)
        presenter.refresh()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        prepare()
    }

    func openQuestionView(questionId: Int) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "QuestionViewController") as! QuestionViewController
        vc.setPresenter(presenter: QuestionViewPresenter(questionId: questionId))
        MyNavigationController.instance().show(vc, sender: nil)
    }

    func applyFilter(_ filter: QuestionsTablePresenter.FilterType) {
        presenter.applyFilter(type: filter)
        presenter.refresh()
    }
}
