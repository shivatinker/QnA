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
    private var cellAlpha: CGFloat = 1.0

    override func willMove(toSuperview newSuperview: UIView?) {
        delegate = self
        dataSource = self
        register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: cell_id)
    }

    // MARK: Public API
    public weak var superviewDelegate: QuestionsTableDelegate?

    public func setCells(_ data: [QuestionsTableViewCellData], silent: Bool) {
        clear()
        self.cellsData = data
        reloadData()
        if !silent {
            cellAlpha = 0.0
            for cell in visibleCells as [UITableViewCell] {
                cell.alpha = 0
                UIView.animate(withDuration: 0.5, animations: { cell.alpha = 1 })
            }
        }
    }

    public func clear() {
        self.cellsData.removeAll()
        reloadData()
    }

}

// MARK: Table protocols
extension QuestionsTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
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
