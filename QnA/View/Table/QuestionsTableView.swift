//
//  QuestionsTableView.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit
import Foundation

protocol QuestionsTableDelegate: NSObjectProtocol {
    func onRowClicked(row: Int, cell: QuestionsTableViewCellData)
}

struct QuestionsTableViewCellData {
    var questionText: String
    var questionAuthorName: String
    var isAnswered: Bool
}

// TODO: Refactor using composition instead of inheritance, maybe inherit UITableVC instead of inheriting UITV
/**
 #Table, containing some list of questions
 */
class QuestionsTableView: UITableView {

    // MARK: Private
    private let cell_id = "abcd"
    private var cellsData = [QuestionsTableViewCellData]()

    override func willMove(toSuperview newSuperview: UIView?) {
        delegate = self
        dataSource = self
        register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: cell_id)
    }

    // MARK: Public API
    public weak var superviewDelegate: QuestionsTableDelegate?

    public func setCells(_ data: [QuestionsTableViewCellData]) {
        clear()
        self.performBatchUpdates({
            self.cellsData = data
            for i in 0..<data.count {
                self.insertRows(at: [IndexPath(row: i, section: 0)], with: .fade)
            }
        }, completion: nil)
    }

    public func clear() {
        self.performBatchUpdates({
            let indices = Array(0..<self.cellsData.count).map({ IndexPath(row: $0, section: 0) })
            self.deleteRows(at: indices, with: .fade)
            self.cellsData.removeAll()
        }, completion: nil)
    }

}

// MARK: Table protocols
extension QuestionsTableView: UITableViewDataSource, UITableViewDelegate {
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
        superviewDelegate?.onRowClicked(row: indexPath.row, cell: cellsData[indexPath.row])
    }
}
