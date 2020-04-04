//
//  AskViewControllerPresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 04.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

protocol AskViewDelegate {
    func setData(_ data: AskViewData)
    func startLoading()
    func stopLoading()
    func success()
}

struct AskViewData {
    var username: String
}

class AskViewControllerPresenter {
    // MARK: Private members

    private var dataProvider = DataProviderManager.getDefaultDataProvider()

    // MARK: Public API
    public var delegate: AskViewDelegate?
    public var errorHandler: ErrorHandler?
    public var parentPresenter: QuestionsListViewPresenter?

    public func refresh() {
        // Data binding
        delegate?.setData(AskViewData(
            username: dataProvider.getUsername()))
    }

    public func askQuestion(_ text: String) {
        delegate?.startLoading()
        // TODO: Ask concrete expert
        dataProvider.askQuestion(question: text, expertId: 1) { mbError in
            if mbError != nil{
                self.delegate?.stopLoading()
                self.errorHandler?.displayError(mbError)
            } else {
                self.parentPresenter?.refresh(silent: true)
                self.delegate?.stopLoading()
                self.delegate?.success()
            }
        }
    }
}
