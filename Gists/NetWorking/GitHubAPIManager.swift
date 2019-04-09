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
import Locksmith

class GitHubAPIManager {
    static let shared = GitHubAPIManager()
    
    let clientID: String = "5608e374f37575b42a6d"
    let clientSecret: String = "19a2b99cf5c3b09ab357667a1a79b3d3b3b22674"
    var OAuthToken: String? {
                set {
                    if let valueToSave = newValue {
                        do {
                            try Locksmith.updateData(data: ["token": valueToSave], forUserAccount: "github")
                        } catch {
                            let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                        }
                    }
                    else { // they set it to nil, so delete it
                        let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                    }
                }
                get {
                    // try to load from keychain
                    Locksmith.loadDataForUserAccount(userAccount: "github")
                    let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
                    if let token = dictionary?["token"] as? String {
                        return token
                    }
                    return nil
                }
    }

    // handlers for the OAuth process
    // stored as vars since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var OAuthTokenCompletionHandler:((NSError?) -> Void)?
    
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
    func printMyGists(completionHandler: @escaping ((Result<[Gist]>)) -> Void) {
        Alamofire.request(GistRouter.GetMine())
            .responseArray(queue: nil) { (response) in
                completionHandler(response.result)
                
                
        }
    }
    
    
    func printMyStarredGistsWithOAuth2(completionHandler: @escaping ((Result<[Gist]>)) -> Void) {
        Alamofire.request(GistRouter.GetMyStarred)
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

    func printMyStarredGistsWithOAuth2() -> Void {
        let starredGistsRequest = alamofireManager.request(GistRouter.GetMyStarred)
            .responseString { response in
                guard response.result.error == nil else {
                    print("fali to get gist starred,",response.result.error)
                    GitHubAPIManager.shared.OAuthToken = nil
                    return
                }
                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
        debugPrint(starredGistsRequest)
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

    
        // OAuth flow
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
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
    func swapAuthCodeForToken(receivedCode: String) {
        let getTokenPath:String = receivedCode
        let tokenParams = ["client_id": clientID, "client_secret": clientSecret,
                           "code": receivedCode]
        let jsonHeader = ["Accept": "application/json"]
        Alamofire.request(getTokenPath, method:.post, parameters: tokenParams,
                          headers: jsonHeader)
            .responseString { response in
                if let error = response.result.error {
                    let defaults = UserDefaults.standard
                    defaults.set(false, forKey: "loadingOAuthToken")
                    print(error)
                    return
                }
                
                // like "access_token=999999&scope=gist&token_type=bearer"
                if let receivedResults = response.result.value, let jsonData =
                    receivedResults.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    guard let jsonResults = try? JSON(data: jsonData) else {return }
                    for (key, value) in jsonResults {
                        switch key {
                        case "access_token":
                            self.OAuthToken = value.string
                        case "scope":
                            // TODO: verify scope
                            print("SET SCOPE")
                        case "token_type":
                            // TODO: verify is bearer
                            print("CHECK IF BEARER")
                        default:
                            print("got more than I expected from the OAuth token exchange")
                            print(key)
                        }
                    }
                }
                if (self.hasOAuthToken()) {
                    self.printMyStarredGistsWithOAuth2()
                }
        }
    }
    
    func processOAuthStep1Response(url: URL) {
        //parse received url query to get token
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        var code:String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercased() == "code") {
                    code = queryItem.value
                    break
                }
            }
        }
        if let receivedCode = code {
            swapAuthCodeForToken(receivedCode: receivedCode)
        } else {
            // no code in URL that we launched with
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "loadingOAuthToken")
        }
    }
    
    func checkUnauthorized(urlResponse: HTTPURLResponse) -> (NSError?) {
        if (urlResponse.statusCode == 401) {
            self.OAuthToken = nil
            let lostOAuthError = NSError(domain: NSURLErrorDomain,
                                         code: NSURLErrorUserAuthenticationRequired,
                                         userInfo: [NSLocalizedDescriptionKey: "Not Logged In",
                                                    NSLocalizedRecoverySuggestionErrorKey: "Please re-enter your GitHub credentials"])
            return lostOAuthError
        }
        return nil
    }
    

    //MARK:- Starred
    
    func isGistStarred(gistId: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        // GET /gists/:id/star
        alamofireManager.request(GistRouter.IsStarred(gistId))
            .validate(statusCode: [204])
            .response { (response) in
                // auth check
                if let urlResponse = response.response, let authError = self.checkUnauthorized(urlResponse: urlResponse) {
                    completionHandler(.failure(authError))
                    return
                }
                // 204 if starred, 404 if not
                if let error = response.error {
                    print(error)
                    if response.response?.statusCode == 404 {
                        completionHandler(.success(false))
                        return
                    }
                    completionHandler(.failure(error))
                    return
                }
                completionHandler(.success(true))
        }
    }
    func starGist(gistId: String, completionHandler: @escaping(NSError?) -> Void) {
        alamofireManager.request(GistRouter.Star(gistId))
            .response { (response) in
                // auth check
                if let urlResponse = response.response, let authError = self.checkUnauthorized(urlResponse: urlResponse) {
                    completionHandler(authError)
                    return
                }
                
                if let error = response.error {
                    print(error)
                    return
                }
                completionHandler(response.error as NSError?)
        }
    }
    func unstarGist(gistId: String, completionHandler: @escaping(NSError?) -> Void) {
        alamofireManager.request(GistRouter.Unstar(gistId))
            .response { (response) in
                // auth check
                if let urlResponse = response.response, let authError = self.checkUnauthorized(urlResponse: urlResponse) {
                    completionHandler(authError)
                    return
                }
                if let error = response.error {
                    print(error)
                    return
                }
                completionHandler(response.error as NSError?)
        }
    }
}
