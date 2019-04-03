//
//  AlamofireRequest+JSONSerializable.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/3.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Alamofire.DataRequest {

    public func responseArray<T:ResponseJSONObjectSerializable> (
        queue: DispatchQueue? = nil ,
        completionHandler: @escaping (DataResponse<[T]>) -> Void ) -> Self{
        
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil else {return .failure(BackendError.network(error: error!))}
            guard let responseData = data else {
                return .failure(BackendError.dataSerialization(error: error!))
                
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            switch result {
                case .success(let jsonData):
                
                    let json = SwiftyJSON.JSON(jsonData)
                    var objects: [T] = []
                    for (_, item) in json {
                        if let object = T.init(json: item) {
                            objects.append(object)
                        }
                    }
                    return .success(objects)
                case .failure(let error):
                    return .failure(BackendError.jsonSerialization(error: error))
                }
            
            }
        return response(queue:queue,responseSerializer: responseSerializer, completionHandler: completionHandler)
       
    }
}

