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
    
    //MARK:- API FUNCTION
    
    func printPublicGists(completionHandler: @escaping ((Result<[Gist]>)) -> Void) {
        Alamofire.request(GistRouter.GetPublic)
            .responseArray(queue: nil) { (response) in
                completionHandler(response.result)
        }
    }
    
    func imageFromURLString(imageURLString: String, completionHandler:@escaping
        (UIImage?, NSError?) -> Void) {
        alamofireManager.request(imageURLString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .response { (response) in
                guard let data = response.data else {
                    completionHandler(nil, nil)
                    return
                }
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }

    }
}

