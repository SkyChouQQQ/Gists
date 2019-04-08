//
//  Gist.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/2.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import SwiftyJSON

class Gist:ResponseJSONObjectSerializable {
    var id: String?
    var description: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var url: String?
    var files:[File]?
    var createdAt:Date?
    var updatedAt:Date?
    
    static let sharedDateFormatter = Gist.dateFormatter()
    
    required init?(json: JSON) {
        self.description = json["description"].string
        self.id = json["id"].string
        self.ownerLogin = json["owner"]["login"].string
        self.ownerAvatarURL = json["owner"]["avatar_url"].string
        self.url = json["url"].string
        
        self.files = [File]()
        if let filesJSON = json["files"].dictionary {
            for (_, fileJSON) in filesJSON {
                if let newFile = File(json: fileJSON) {
                    self.files?.append(newFile)
                }
            }
        }
        // Dates
        let dateFormatter = Gist.sharedDateFormatter
        if let dateString = json["created_at"].string {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json["updated_at"].string {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
    }
    required init() {
        
    }
    
    class func dateFormatter() -> DateFormatter {
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
}
