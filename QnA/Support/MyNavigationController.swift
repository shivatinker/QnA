//
//  MyNavigationController.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/31/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    private static var _instance: MyNavigationController?
    public static var instance: MyNavigationController {
        if let _instance = _instance {
            return _instance
        }
        let newInstance = MyNavigationController()
        _instance = newInstance
        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        MyNavigationController._instance = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
