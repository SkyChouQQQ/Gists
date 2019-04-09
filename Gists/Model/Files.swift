//
//  Files.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/8.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import SwiftyJSON

class File: ResponseJSONObjectSerializable,NSCoding {

    var filename: String?
    var raw_url: String?
    var content: String?
    
    required init?(json: JSON) {
        self.filename = json["filename"].string
        self.raw_url = json["raw_url"].string
    }
    init?(aName: String?, aContent: String?) {
        self.filename = aName
        self.content = aContent
        }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.filename, forKey: "filename")
        aCoder.encode(self.raw_url, forKey: "raw_url")
        aCoder.encode(self.content, forKey: "content")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let filename = aDecoder.decodeObject(forKey:"filename") as? String
        let content = aDecoder.decodeObject(forKey:"content") as? String
        // use the existing init function
        self.init(aName: filename, aContent: content)
        self.raw_url = aDecoder.decodeObject(forKey:"raw_url") as? String
    }
    
}
