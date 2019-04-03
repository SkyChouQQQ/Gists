//
//  UIImage+GistAPIManager.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/3.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

let imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    func loadImageUsingCasheWithUrlString(urlString:String) {
        
        self.image = nil
        
        let imageCacheKey = NSString(string: urlString)
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: imageCacheKey) {
            self.image = cacheImage
            return
        }
        
        GitHubAPIManager.shared.imageFromURLString(imageURLString: urlString) { (image, error) in
            if error != nil {
                print("download profile image fails with error ", error as Any)
                return
            }
            guard let downloadedImage = image else { return }
            DispatchQueue.main.async {
                    imageCache.setObject(downloadedImage, forKey: imageCacheKey)
                    self.image = downloadedImage
                print(self.image?.size)
            }
        }
        //otherwise fure iff a new download

    }
}
