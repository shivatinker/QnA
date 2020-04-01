//
//  DataProviderManager.swift
//  QnA
//
//  Created by Andrii Zinoviev on 01.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation

class DataProviderManager {

	private static var defaultDataProvider: ForumDataProvider?

	public static func getDefaultDataProvider() -> ForumDataProvider {
		if let p = defaultDataProvider {
			return p
		}

		let q = Bundle.main.path(forResource: "questions", ofType: "json")!
		let e = Bundle.main.path(forResource: "experts", ofType: "json")!
		do {
			defaultDataProvider = try MockForumDataProvider(
				questionsJson: try Data(contentsOf: URL(fileURLWithPath: q)),
				expertsJson: try Data(contentsOf: URL(fileURLWithPath: e)))
			return defaultDataProvider!
		} catch let e {
			print(e)
			fatalError("Cannot load JSON")
		}

	}
}
