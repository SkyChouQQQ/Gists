//
//  Errors.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/3.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
