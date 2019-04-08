//
//  MasterViewController+Helper.swift
//  Gists
//
//  Created by Admin on 2019/4/3.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import UIKit
import SafariServices
//MARK:- VC Helper function

extension MasterViewController:LoginViewDelegate,SFSafariViewControllerDelegate {

    
    func loadPublicGists() {
        GitHubAPIManager.shared.printPublicGists { (result) in
            guard result.error == nil else {
                print(result.error)
                // TODO: display error
                return
            }
            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }
            self.tableView.reloadData()
        }
        
    }
    func loadStarrredGists() {
        GitHubAPIManager.shared.printMyStarredGistsWithOAuth2 { (result) in
            guard result.error == nil else {
                print(result.error)
                // TODO: display error
                return
            }
            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }
            self.tableView.reloadData()
        }
        
    }
    func loadMyGists() {
        GitHubAPIManager.shared.printMyGists { (result) in
            guard result.error == nil else {
                print(result.error)
                // TODO: display error
                return
            }
            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }
            self.tableView.reloadData()
        }
        
    }
    func loadInitialData() {
        GitHubAPIManager.shared.OAuthTokenCompletionHandler = { (error) -> Void in
            self.safariViewController?.dismiss(animated: true, completion: nil)
            if let error = error {
                print(error)
                // TODO: handle error
                // Something went wrong, try again
                self.showOAuthLoginView()
            } else {
                self.loadPublicGists()
            }
        }
        
        if (!GitHubAPIManager.shared.hasOAuthToken()) {
            showOAuthLoginView()
        } else {
            GitHubAPIManager.shared.printMyStarredGistsWithOAuth2()
        }
    }
    
    fileprivate func showOAuthLoginView() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        present(loginVC, animated: true, completion: nil)
    }
    
    //MARK: - LoginViewDelegate method
    
    func didTapLoginButton() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "loadingOAuthToken")
        
        
        self.dismiss(animated: false, completion: nil)
        
        if let authURL = GitHubAPIManager.shared.URLToStartOAuth2Login() {
            safariViewController = SFSafariViewController(url: authURL)
            safariViewController?.delegate = self
            guard let webVC = safariViewController else {return }
            self.present(webVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Safari View Controller Delegate
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        // Detect not being able to load the OAuth URL
        if (!didLoadSuccessfully) {
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "loadingOAuthToken")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}



