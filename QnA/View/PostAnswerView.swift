//
//  PostAnswerView.swift
//  QnA
//
//  Created by Andrii Zinoviev on 02.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

class PostAnswerView: UIView, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    private weak var delegate: PostAnswerBlockDelegate?

    public func setDelegate(delegate: PostAnswerBlockDelegate){
        self.delegate = delegate
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        textView.delegate = self
    }

    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
    }
    
    @IBAction func onPostAnswerClicked(_ sender: Any) {
        delegate?.postAnswer()
    }
}
