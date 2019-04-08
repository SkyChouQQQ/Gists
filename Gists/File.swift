//
//  File.swift
//  Gists
//
//  Created by Admin on 2019/4/4.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import Alamofire

class test {
    func aFunction(uRLRequest:URLRequestConvertible,completionHandler:@escaping
                    (Result<[Gist]>, String?) -> Void) {
        Alamofire.request(uRLRequest)
        .validate()
        
    }
    
//        func getGists(with uRLRequest:URLRequestConvertible, completionHandler:@escaping
//            (Result<[Gist]>, String?) -> Void) {
//            Alamofire.request(uRLRequest)
//                .validate()
//                .responseArray(queue: nil) { (response) in
//                    guard response.result.error == nil,
//                        let gists = response.result.value else {
//                            print(response.result.error)
//                            completionHandler(response.result, nil)
//                            return
//                    }
//
//                    // check the link header, if present
//                    let next = self.getNextPageFromHeaders(response.response)
//                    completionHandler(.success(gists), next)
//            }
//        }
}
