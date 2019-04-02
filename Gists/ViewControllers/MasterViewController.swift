//
//  MasterViewController.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/2.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import UIKit

class MasterViewController:UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var gists = [Gist]()
    
    //MARK:-VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGist))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as!
                UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GitHubAPIManager.shared.printPublicGists()
    }
    
    //MARK:- target function
    @objc func addGist() {
        
    }
    @objc func editGist() {
        
    }
    
    //MARK:- UI
    fileprivate func editButtonItem()->UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGist))
    }
}
