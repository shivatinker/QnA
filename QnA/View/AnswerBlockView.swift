//
//  AnswerView.swift
//  QnA
//
//  Created by Andrii Zinoviev on 02.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

@IBDesignable
class AnswerBlockView: UIView {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    let nibName = "AnswerView"
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
