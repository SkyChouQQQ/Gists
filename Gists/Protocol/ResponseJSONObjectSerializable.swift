//
//  ResponseJSONObjectSerializable.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/3.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import SwiftyJSON
public protocol ResponseJSONObjectSerializable {
    init?(json: SwiftyJSON.JSON)
}
