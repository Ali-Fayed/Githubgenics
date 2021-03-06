//
//  PublicStarredViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class PublicStarredViewModel {

    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    var passedUser: User?
    var pageNo : Int = 1
    var totalPages : Int = 100
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var numberOfStarredCells: Int {
        return  starttedRepos.count
    }

    func getStarredViewModel( at indexPath: IndexPath ) -> Repository {
        return starttedRepos[indexPath.row]
    }
    
    func loadStarred (tableView: UITableView, view: UIView, loadingSpinner: JGProgressHUD, conditionLabel: UILabel ) {
        guard let repository = passedUser else {return}
        if self.starttedRepos.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, repository.userName)) { [weak self] (result) in
            self?.starttedRepos = result
            DispatchQueue.main.async {
                if self?.starttedRepos.isEmpty == true {
                    tableView.isHidden = true
                    conditionLabel.isHidden = false

                } else {
                    tableView.isHidden = false
                    conditionLabel.isHidden = true
                }
                loadingSpinner.dismiss()
                tableView.reloadData()
            }
        }
    }
    
    func fetchMoreStarredRepos (at indexPath: IndexPath, tableView: UITableView, tableFooterView: UIView, loadingSpinner: JGProgressHUD) {
        
        if indexPath.row == numberOfStarredCells - 1 {
            if pageNo < totalPages {
                pageNo += 1
                guard let user = passedUser else {return}
                GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, user.userName), pagination: true) { [weak self]  (moreStarredRepos) in
                    DispatchQueue.main.async {
                        if moreStarredRepos.isEmpty == false {
                            self?.starttedRepos.append(contentsOf: moreStarredRepos)
                            tableView.reloadData()
                            tableView.tableFooterView = nil
                        } else {
                            tableView.tableFooterView = tableFooterView
                        }
                    }
                }
            }
        }
    }
    
    func saveRepoToBookmarks(at indexPath: IndexPath) {
        let saveRepoInfo = SavedRepositories(context: self.context)
        let repository = starttedRepos[indexPath.row]
            saveRepoInfo.repoName = repository.repositoryName
            saveRepoInfo.repoDescription = repository.repositoryDescription
            saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
            saveRepoInfo.repoUserFullName = repository.repoFullName
            saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
            saveRepoInfo.repoURL = repository.repositoryURL
    }
    
    func pushToDestnationVC(indexPath: IndexPath, navigationController: UINavigationController ) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = starttedRepositories
        navigationController.pushViewController(vc!, animated: true)
    }
    
}
