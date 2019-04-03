//
//  GitHubAPIManager.swfit.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/2.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GitHubAPIManager {
    static let shared = GitHubAPIManager()
    
    var alamofireManager = Alamofire.SessionManager()
    init () {
        let configuration = URLSessionConfiguration.default
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func printPublicGists(completionHandler: @escaping ((Result<[Gist]>)) -> Void) {
        Alamofire.request(GistRouter.GetPublic)
            .responseArray(queue: nil) { (response) in
                completionHandler(response.result)
        }
    }
}
