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
    
    let clientID: String = "5608e374f37575b42a6d"
    let clientSecret: String = "19a2b99cf5c3b09ab357667a1a79b3d3b3b22674"
    
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

    private func getNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        if let linkHeader = response?.allHeaderFields["Link"] as? String {
            /* looks like:
             <https://api.github.com/user/20267/gists?page=2>; rel="next", <https://api.github.com/\
             user/20267/gists?page=6>; rel="last"
             */
            // so split on "," then on ";"
            let components = linkHeader.split {$0 == ","}.map { String($0) }
            // now we have 2 lines like
            // '<https://api.github.com/user/20267/gists?page=2>; rel="next"'
            // So let's get the URL out of there:
            for item in components {
                // see if it's "next"
                let rangeOfNext = item.range(of: "rel=\"next\"", options: [], range: nil, locale: nil)
                if rangeOfNext != nil {
                    let rangeOfPaddedURL = item.range(of: "<(.*)>;", options: .regularExpression, range: nil, locale:nil)
                    if let range = rangeOfPaddedURL {
                        let nextURL = String(item[range])
                        // strip off the < and >;
                          let startIndex = nextURL.index(nextURL.startIndex, offsetBy: 1)
                          let endIndex = nextURL.index(nextURL.endIndex, offsetBy: -2)
                          let urlRange = startIndex..<endIndex
                          return String(nextURL[urlRange])
                    }
                }
            }
           
        }
        return nil
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

// MARK:- Pagination not working
extension GitHubAPIManager {

//    func getGists(with uRLRequest:URLRequestConvertible, completionHandler:@escaping
//        (Result<[Gist]>, String?) -> Void) {
//        let aURLRequest = uRLRequest
//        Alamofire.request(aURLRequest).responseArray(queue: nil) { (response) in
//            guard response.result.error == nil,
//                let gists = response.result.value else {
//                    print(response.result.error)
//                    completionHandler(response.result, nil)
//                    return
//            }
//
//             check the link header, if present
//            let next = self.getNextPageFromHeaders(response.response)
//            completionHandler(.success(gists), next)
//        }
//    }
//    func getPublicGists(pageToLoad: String?, completionHandler:@escaping
//        (Result<[Gist]>, String?) -> Void) {
//        if let urlString = pageToLoad {
//            getGists(with: GistRouter.GetAtPath(urlString), completionHandler: completionHandler)
//        } else {
//            getGists(with: GistRouter.GetPublic, completionHandler: completionHandler)
//        }
//    }
    
}

// MARK:- Star

extension GitHubAPIManager {
    func printMyStarredGistsWithBasicAuth() -> Void {
        Alamofire.request(GistRouter.GetMyStarred)
            .responseString { response in
                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
    }
    //HTTP Bin test auth function
    func doGetWithBasicAuth() -> Void {
        let username = "SkyChouQQQ"
        let password = "Aaaa230487"
        
        let credential = URLCredential(user: username, password: password,persistence: URLCredential.Persistence.forSession)
        Alamofire.request( "https://httpbin.org/basic-auth/\(username)/\(password)", method:.get)
            .authenticate(usingCredential: credential)
            .responseString { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
    }
    
    // MARK: - OAuth 2.0
    // API call without authentication
    func printMyStarredGistsWithOAuth2() -> Void {
        alamofireManager.request(GistRouter.GetMyStarred)
            .responseString { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
    }
    
        // MARK: - OAuth flow
    func hasOAuthToken() -> Bool {
        // TODO: implement
        return false
    }
    

    func URLToStartOAuth2Login() -> URL? {
        let authPath:String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(clientID)&scope=gist&state=TEST_STATE"
        guard let authURL:URL = URL(string: authPath) else {
            // TODO: handle error
            return nil
        }
        print(authURL)
        return authURL
    }
}
