//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit

class CommitsViewController: UITableViewController {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var commits = [Commit]()
    var repository : Repository?
    var userRepositories : UserRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        renderSearchedRepositoriesCommits()
        renderUserRepositoriesCommits()
        navigationItem.title = Titles.commitsViewTitle
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = Titles.commitsViewTitle
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}