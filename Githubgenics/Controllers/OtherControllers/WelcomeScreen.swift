//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectTextView: UITextView!
    @IBOutlet weak var HelloWorld: UILabel!
    @IBOutlet weak var SignInBT: UIButton!
    @IBOutlet weak var SignUpBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectTitle.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        projectTitle.text = "GITHUBGENICS".localized()
        HelloWorld.text = "Hello World!".localized()
        SignInBT.setTitle("Sign In".localized(), for: .normal)
        SignUpBT.setTitle("Sign Up".localized(), for: .normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func AutoSignIn(_ sender: Any) {
        if UserDefaults.standard.value(forKeyPath: "email") != nil {
            performSegue(withIdentifier: "Main", sender: self)
        } else {
            performSegue(withIdentifier: "Default", sender: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        
    }
}