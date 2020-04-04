//
//  AskViewController.swift
//  QnA
//
//  Created by Andrii Zinoviev on 04.04.2020.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var postButton: UIButton!
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    public var presenter: AskViewControllerPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.delegate = self
        presenter?.errorHandler = AlertErrorHandler(parent: self)
        
        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: false)
        
        presenter?.refresh()
    }
    
    @IBAction func onPostButtonClicked(_ sender: Any) {
        presenter?.askQuestion(textView.text)
    }
}

extension AskViewController: AskViewDelegate{
    func setData(_ data: AskViewData) {
        DispatchQueue.main.async {
            self.headerLabel.text = "Ask something as \(data.username):"
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func success() {
        DispatchQueue.main.async {
            MyNavigationController.instance.popViewController(animated: true)
        }
    }
}
