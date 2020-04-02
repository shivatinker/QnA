//
//  QuestionsBrowserViewPresenter.swift
//  QnA
//
//  Created by Andrii Zinoviev on 02.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

protocol QuestionsBrowserViewDelegate: ErrorHandler {
    
}

class QuestionsBrowserViewPresenter {

    
    
    private weak var delegate: QuestionsTableViewDelegate?
    
    public func setDelegate(_ delegate: QuestionsTableViewDelegate) {
        self.delegate = delegate
    }
}
