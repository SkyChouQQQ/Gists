//
//  DetailViewController.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/2.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController:UIViewController {
    
    private var detailTableView: UITableView!
    let cellId = "cellId"
    var gist:Gist? {
        didSet {
            //
        }
    }
    var isStarred: Bool?
    var alertController:UIAlertController?

    fileprivate func setupView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        detailTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        detailTableView.dataSource = self
        detailTableView.delegate = self
        self.view.addSubview(detailTableView)
        
         detailTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        view.backgroundColor = .white
    }
    

}

//  MARK:-TableView method

extension DetailViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let _ = isStarred {
                return 3
            }
            return 2
        } else {
            return gist?.files?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
        guard let gist = self.gist else {return cell}
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = gist.description
            } else if indexPath.row == 1 {
                cell.textLabel?.text = gist.ownerLogin
            } else {
                if let starred = isStarred {
                    if starred {
                        cell.textLabel?.text = "Unstar"
                    } else {
                        cell.textLabel?.text = "Star"
                    }
                }
            }
        } else {
            if let file = gist.files?[indexPath.row] {
                cell.textLabel?.text = file.filename
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "About"
        } else {
            return "Files"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let file = self.gist?.files?[indexPath.row],let urlString = file.raw_url, let url = URL(string: urlString) {
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.title = file.filename
                self.navigationController?.pushViewController(safariViewController, animated: true)
            }
        }
    }
}

// MARK:- Star manipulation
extension DetailViewController {
    
    fileprivate func fetchStarredStatus() {
        if let gistId = gist?.id {
            GitHubAPIManager.shared.isGistStarred(gistId: gistId, completionHandler: {
                result in
                if let error = result.error {
                    print(error)
                }
                if let status = result.value, self.isStarred == nil { // just got it
                    self.isStarred = status
                    // update display
                    
                    self.detailTableView?.insertRows(at:[IndexPath(row: 2, section: 0)],with: .automatic)
                }
            })
        }
    }
    
    func starThisGist() {
        if let gistId = gist?.id {
            GitHubAPIManager.shared.starGist(gistId: gistId, completionHandler: {
                (error) in
                if let error = error {
                    print(error)
                    
                    if error.domain == NSURLErrorDomain &&
                        error.code == NSURLErrorUserAuthenticationRequired {
                        self.alertController = UIAlertController(title: "Could not star gist",
                                                                 message: error.description, preferredStyle: .Alert)
                    } else {
                        self.alertController = UIAlertController(title: "Could not star gist",
                                                                 message: "Sorry, your gist couldn't be starred. " +
                            "Maybe GitHub is down or you don't have an internet connection.",
                                                                 preferredStyle: .alert)
                    }
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.alertController?.addAction(okAction)
                    self.present(self.alertController!, animated:true, completion: nil)
                } else {
                    self.isStarred = true
                    self.detailTableView?.insertRows(at:[IndexPath(row: 2, section: 0)],with: .automatic)
                    
                }
            })
        }
    }
    func unstarThisGist() {
        if let gistId = gist?.id {
            GitHubAPIManager.shared.unstarGist(gistId: gistId, completionHandler: {
                (error) in
                if let error = error {
                    print(error)
                } else {
                    self.isStarred = false
                    self.detailTableView?.insertRows(at:[IndexPath(row: 2, section: 0)],with: .automatic)
                }
            })
        }
    }
}
