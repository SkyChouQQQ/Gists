//
//  LoginViewController.swift
//  Gists
//
//  Created by Admin on 2019/4/7.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewDelegate: class {
    func didTapLoginButton()
}

class LoginViewController:UIViewController {
    
    weak var delegate:LoginViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupView()
    }
    
    lazy var loginButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setTitle("Login with GitHub", for: .normal)
        bu.setTitleColor(.black, for: .normal)
        bu.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bu.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        bu.translatesAutoresizingMaskIntoConstraints = false
        return bu
    }()
    
    fileprivate func setupView() {
        view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func loginButtonTapped() {
        delegate?.didTapLoginButton()
    }
}
