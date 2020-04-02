//
//  ViewController.swift
//  QnA
//
//  Created by Andrew Zinoviev on 3/30/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit


class ViewController: UIViewController, QuestionsTableDelegate {

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayError(_ text: String) {
        print("Error \(text)")
        //TODO: Error display
    }
    

    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var askButton: UIBarButtonItem!
    @IBOutlet weak var tableView: QuestionsTableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: activityIndicator))
        tableView.setDelegate(delegate: self)
    }

    @IBAction func onFilterClicked(){
        let alert = UIAlertController(title: nil, message: "Choose filter", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All questions", style: .default, handler: { (alert) in
            self.tableView.applyFilter(.allQuestions)
        }))
        alert.addAction(UIAlertAction(title: "With answer", style: .default, handler: { (alert) in
            self.tableView.applyFilter(.onlyAnswered)
        }))
        alert.addAction(UIAlertAction(title: "Without answer", style: .default, handler: { (alert) in
            self.tableView.applyFilter(.onlyUnanswered)
        }))
        
        if let popoverController = alert.popoverPresentationController {
          popoverController.barButtonItem = filterButton
        }

        self.present(alert, animated: true, completion: nil)
    }
}

