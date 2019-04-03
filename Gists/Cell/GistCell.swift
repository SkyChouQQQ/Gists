//
//  GistCell.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/3.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import PINRemoteImage

class GistCell:UITableViewCell {
    
    var gist:Gist? {
        didSet {
            
            setUpNameAndProfileImage()
        }
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        setUpView()
    }
    
    private func setUpView() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    private func setUpNameAndProfileImage() {
        self.textLabel?.text = gist?.description
        self.detailTextLabel?.text = gist?.ownerLogin
        if let urlString = gist?.ownerAvatarURL, let url = URL(string: urlString) {
            self.profileImageView.pin_setImage(from: url, placeholderImage: UIImage(named: "default"))
//            custom image cashe
//            self.profileImageView.loadImageUsingCasheWithUrlString(urlString: urlString)
        } else {
            
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
