//
//  CommonProtocols.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

protocol ErrorHandler: NSObjectProtocol {
    func displayError(_ error: Error?)
    func displayError(text: String?)
}
