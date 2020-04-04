//
//  AlertErrorHandler.swift
//  QnA
//
//  Created by Andrii Zinoviev on 04.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import UIKit

class AlertErrorHandler: NSObject, ErrorHandler {
    private weak var parent: UIViewController?

    init(parent: UIViewController) {
        self.parent = parent
    }

    func displayError(_ error: Error?) {
        displayError(text: error?.localizedDescription)
    }

    func displayError(text: String?) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Fine", style: .cancel, handler: nil))
            self.parent?.present(ac, animated: true, completion: nil)
        }
    }
}
