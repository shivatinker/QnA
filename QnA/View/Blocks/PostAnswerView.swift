//
//  PostAnswerView.swift
//  QnA
//
//  Created by Andrii Zinoviev on 02.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

protocol PostAnswerBlockViewDelegate: NSObjectProtocol {
    func onPostAnswerClicked()
}

class PostAnswerBlockView: UIView, UITextViewDelegate {

    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var headerLabel: UILabel!
    public weak var delegate: PostAnswerBlockViewDelegate?

    public func setUsername(username: String) {
        // TODO: Add bold username
        headerLabel.text = "Post answer as \(username):"
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        textView.delegate = self
    }

    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
    }

    @IBAction func onPostAnswerClicked(_ sender: Any) {
        delegate?.onPostAnswerClicked()
    }
}
