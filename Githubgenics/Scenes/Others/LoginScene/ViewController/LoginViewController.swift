//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SafariServices
import AuthenticationServices


class LoginViewController: ViewSetups {
    
    @IBOutlet weak var signInWithGitHub: UIButton!
    @IBOutlet weak var Privacy: UIButton!
    @IBOutlet weak var term: UIButton!
    @IBOutlet weak var and: UILabel!
    @IBOutlet weak var bySign: UILabel!
    var webAuthenticationSession: ASWebAuthenticationSession?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView()  {
        signInWithGitHub.layer.cornerRadius = 20
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        signInWithGitHub.setTitle(Titles.signInWithGithubTitle , for: .normal)
        Privacy.setTitle(Titles.privacyPolicyTitle, for: .normal)
        term.setTitle(Titles.termsOfUseTitle, for: .normal)
        and.text = Titles.and
        bySign.text = Titles.bySign
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        signInWithGitHub.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signInWithGitHub.layer.cornerRadius = 20
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        let url = "https://docs.github.com/en/github/site-policy/github-privacy-statement"
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    
    @IBAction func terms(_ sender: Any) {
        let url = "https://docs.github.com/en/github/site-policy/github-terms-of-service"
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        // vibaration when sign in
        HapticsManger.shared.selectionVibrate(for: .medium)
        let sheet = UIAlertController(title: "", message: Titles.makeSure , preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: Titles.signInWithGithubTitle, style: .default, handler: { (url) in
            // call authentication method
            self.getGitHubAccessToken ()
        }))
        
        // sheet alert between guest and authenticated member
        sheet.addAction(UIAlertAction(title: Titles.guestModeTitle , style: .default, handler: { (url) in
            let alert = UIAlertController(title: "", message: Titles.byContinue , preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            let action = UIAlertAction(title: Titles.continueLabel, style: .default) { (action) in

                let vc = UIStoryboard.init(name: Storyboards.tabBarView, bundle: Bundle.main).instantiateViewController(withIdentifier: ID.tabBarViewControllerID) as? TabBarViewController
                vc?.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
            alert.addAction(action)
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
        present(sheet, animated: true)
    }
}

extension LoginViewController {
    
    func getGitHubAccessToken () {
        var authorizeURLComponents = URLComponents(string: GitHubConstants.authorizeURL)
        authorizeURLComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: GitHubConstants.clientID),
            URLQueryItem(name: "scope", value: GitHubConstants.scope)
        ]
        guard let authorizeURL = authorizeURLComponents?.url else {
            return
        }
        webAuthenticationSession = ASWebAuthenticationSession.init(
            url: authorizeURL,
            callbackURLScheme: GitHubConstants.redirectURI) { (callBack: URL?, error: Error?) in
            guard
                error == nil,
                let successURL = callBack
            else {
                return
            }
            //Retrieve access code
            guard let accessCode = URLComponents(string: (successURL.absoluteString))?
                    .queryItems?.first(where: { $0.name == "code" })?.value else {
                return
            }
            //fetch token using access code
            GitTokenManager.shared.fetchAccessToken(accessToken: accessCode) { isSuccess in
                self.handlesignin(success: isSuccess)
            }
        }
        webAuthenticationSession?.presentationContextProvider = self
        webAuthenticationSession?.start()
    }
    
    private func handlesignin(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            return
        }
        let vc = UIStoryboard.init(name: Storyboards.tabBarView, bundle: Bundle.main).instantiateViewController(withIdentifier: ID.tabBarViewControllerID) as? TabBarViewController
            vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}


extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
