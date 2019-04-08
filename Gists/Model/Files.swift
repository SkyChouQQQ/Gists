//
//  Files.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/8.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import SwiftyJSON

class File: ResponseJSONObjectSerializable {
    var filename: String?
    var raw_url: String?
    required init?(json: JSON) {
        self.filename = json["filename"].string
        self.raw_url = json["raw_url"].string
    }
}
