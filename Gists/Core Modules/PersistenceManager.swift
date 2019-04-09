//
//  PersistenceManager.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/9.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation

enum Path: String {
    case Public = "Public"
    case Starred = "Starred"
    case MyGists = "MyGists"
}

class PersistenceManager {
    
    class func saveArray<T: NSCoding>(arrayToSave: [T], path: Path) {
        let file = documentsDirectory() + path.rawValue
        NSKeyedArchiver.archiveRootObject(arrayToSave, toFile: file)
        
    }
    
    class func loadArray<T: NSCoding>(path: Path) -> [T]? {
        let file = documentsDirectory() + path.rawValue
        let result = NSKeyedUnarchiver.unarchiveObject(withFile: file)
        return result as? [T]
    }
    
    class private func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let documentDirectory = paths[0] as String
        return documentDirectory
    }
}
