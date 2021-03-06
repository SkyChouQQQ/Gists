//
//  GistRouter.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/2.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import Alamofire

enum GistRouter:URLRequestConvertible {
    
    static let baseURLString:String = "https://api.github.com"
    
    
    
    case GetPublic // GET https://api.github.com/gists/public
    case GetAtPath(String) // GET at given path
    case GetMyStarred //GET https://api.github.com/gists/starred
    case GetMine() // GET https://api.github.com/gists
    case IsStarred(String) // GET https://api.github.com/gists/\(gistId)/star
    case Star(String) // PUT https://api.github.com/gists/\(gistId)/star
    case Unstar(String) // DELETE https://api.github.com/gists/\(gistId)/star
    case Delete(String) // DELETE https://api.github.com/gists/\(gistId)
    case Create([String: AnyObject]) // POST https://api.github.com/gists
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetPublic:
            return .get
        case .GetAtPath:
            return .get
        case .GetMyStarred:
            return .get
        case .GetMine:
            return .get
        case .IsStarred:
            return .get
        case .Star:
            return .put
        case .Unstar:
            return .delete
        case .Delete:
            return .delete
        case .Create:
            return .post
        }
    }
    
    var result: (path: String, parameters: [String: Any]?)  {
        switch self {
        case .GetPublic:
            return ("/gists/public", nil)
        case .GetAtPath(let path):
            let URL = NSURL(string: path)
            let relativePath = URL!.relativePath!
            return (relativePath, nil)
        case .GetMyStarred:
            return ("/gists/starred", nil)
        case .GetMine:
            return ("/gists", nil)
        case .IsStarred(let id):
            return ("/gists/\(id)/star", nil)
        case .Star(let id):
            return ("/gists/\(id)/star", nil)
        case .Unstar(let id):
            return ("/gists/\(id)/star", nil)
        case .Delete(let id):
            return ("/gists/\(id)", nil)
        case .Create(let params):
            return ("/gists", params)
        }

    }
    
    func asURLRequest() throws -> URLRequest {
        
        let URL = NSURL(string: GistRouter.baseURLString)!
        var uRLRequest = URLRequest(url: URL.appendingPathComponent(result.path)!)
        uRLRequest.httpMethod = method.rawValue
        
         // basic auth test code
//        let username = "SkyChouQQQ"
//        let password = "Aaaa230487"
//        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
//        let base64Credentials = credentialData.base64EncodedString(options: [])
//        uRLRequest.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")

//        Set OAuth token if we have one
        if let token = GitHubAPIManager.shared.OAuthToken {
            uRLRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
//        set parameters
        if let parameters = result.parameters {
                uRLRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        
        
        return uRLRequest

    }
}
