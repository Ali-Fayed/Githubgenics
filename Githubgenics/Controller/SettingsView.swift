//
//  SettingsView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import WebKit
import Alamofire
import Kingfisher

class SettingsView: UITableViewController {
     
    var Setting = ["Dark Mode" , "Languages" , "About" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return Setting.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = Setting[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}