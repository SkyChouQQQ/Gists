//
//  MasterViewController.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/2.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import UIKit

class MasterViewController:UITableViewController {
    
    var gists = [Gist]()
    let cellId = "cellId"
    
    //MARK:-VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBarUI()
        tableView.register(GistCell.self, forCellReuseIdentifier: cellId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadGists()
    }
    
    //MARK:- target function
    @objc func addGist() {
        let alert = UIAlertController(title: "Not Implemented", message:
            "Can't create new gists yet, will implement later",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func editGist() {
        
    }
    
    //MARK:- UI
    fileprivate func editButtonItem()->UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGist))
    }
    
    fileprivate func setupNaviBarUI() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGist))
        self.navigationItem.rightBarButtonItem = addButton

    }
    
    //MARK:- VC Helper function
    fileprivate func loadGists() {
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
    
    //MARK:- memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func showGistDetailVC(with gist:Gist) {
        let detailVC = DetailViewController()
        detailVC.gist = gist
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK:- TableVC delegate
extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gist = gists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GistCell
        cell.gist = gist
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gist = gists[indexPath.row]
        self.showGistDetailVC(with: gist)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array,
            // and add a new row to the table view.
        }
    }

}
