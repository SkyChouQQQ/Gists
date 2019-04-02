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
    
    func printPublicGists() {
        Alamofire.request(GistRouter.GetPublic)
            .responseString { (response) in
                if let responseString = response.result.value {
                    print(responseString)
                }
        }
    }
}
