//
//  QuestionTableViewCell.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

@IBDesignable
class QuestionTableViewCell: UITableViewCell {

	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var questionTextLabel: UILabel!
	@IBOutlet weak var answeredView: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
}
