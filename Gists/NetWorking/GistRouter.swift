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
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetPublic:
            return .get
        }
    }
    
    var result: (path: String, parameters: [String: Any]?)  {
        switch self {
        case .GetPublic:
            return ("/gists/public", nil)
        }
    }
    
    
    
    func asURLRequest() throws -> URLRequest {
        let URL = NSURL(string: GistRouter.baseURLString)!
        
        var uRLRequest = URLRequest(url: URL.appendingPathComponent(result.path)!)
        uRLRequest.httpMethod = method.rawValue
        return try Alamofire.JSONEncoding.default.encode(uRLRequest, with: result.parameters)
    }
}
