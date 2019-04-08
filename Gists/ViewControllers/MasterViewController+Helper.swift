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

    
    func loadGists() {
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
    func loadInitialData() {
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
            // TODO: handle this better
            controller.dismiss(animated: true, completion: nil)
        }
    }
}


