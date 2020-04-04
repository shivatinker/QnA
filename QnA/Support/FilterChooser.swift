//
//  FilterChooser.swift
//  QnA
//
//  Created by Andrii Zinoviev on 04.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import UIKit

typealias FilterCallback = (QuestionsListViewPresenter.FilterType) -> Void

class FilterChooser {
    private weak var parent: UIViewController?

    init(parent: UIViewController) {
        self.parent = parent
    }

    public func show(callback: @escaping FilterCallback) {
        let alert = UIAlertController(title: nil, message: "Choose filter", preferredStyle: .actionSheet)
        let actions = [
            UIAlertAction(title: "All questions", style: .default, handler: { (alert) in
                callback(.allQuestions)
            }),
            UIAlertAction(title: "With answer", style: .default, handler: { (alert) in
                callback(.onlyAnswered)
            }),
            UIAlertAction(title: "Without answer", style: .default, handler: { (alert) in
                callback(.onlyUnanswered)
            }),
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)]

        actions.forEach({ alert.addAction($0) })

        parent?.present(alert, animated: true, completion: nil)
    }
}
