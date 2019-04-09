//
//  CreateGistViewController.swift
//  Gists
//
//  Created by Chou Shih-Kai on 2019/4/9.
//  Copyright © 2019 Chou Shih-Kai. All rights reserved.
//

import Foundation
import UIKit
import XLForm

class CreateGistViewController:XLFormViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    //MARK:- Set up form
    private func initializeForm() {
        let form = XLFormDescriptor(title: "Gist")
        // Section 1
        let section1 = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
        form.addFormSection(section1)
        let descriptionRow = XLFormRowDescriptor(tag: "description", rowType:
            XLFormRowDescriptorTypeText, title: "Description")
        descriptionRow.isRequired = true
        section1.addFormRow(descriptionRow)
        
        let isPublicRow = XLFormRowDescriptor(tag: "isPublic", rowType:
            XLFormRowDescriptorTypeBooleanSwitch, title: "Public?")
        isPublicRow.isRequired = false
        section1.addFormRow(isPublicRow)
        
        // Section 2
        let section2 = XLFormSectionDescriptor.formSection(withTitle: "File 1") as
        XLFormSectionDescriptor
        form.addFormSection(section2)
        
        let filenameRow = XLFormRowDescriptor(tag: "filename", rowType:
            XLFormRowDescriptorTypeText, title: "Filename")
        filenameRow.isRequired = true
        section2.addFormRow(filenameRow)
        
        let fileContent = XLFormRowDescriptor(tag: "fileContent", rowType:
            XLFormRowDescriptorTypeTextView, title: "File Content")
        fileContent.isRequired = true
        section2.addFormRow(fileContent)
        
        self.form = form
    }
    //MARK:- VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
    }
    
    
    
    //MARK:- VC UI
    fileprivate func setupNaviBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.save, target: self, action: #selector(savePressed))
    }
    
    @objc func cancelPressed(button: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func savePressed(button: UIBarButtonItem) {
        let validationErrors = self.formValidationErrors() as? [NSError]
        if validationErrors?.count ?? 0 > 0 {
            self.showFormValidationError(validationErrors!.first)
            return
        }
        
        self.tableView.endEditing(true)
        let isPublic: Bool
        if let isPublicValue = form.formRow(withTag: "isPublic")?.value as? Bool {
            isPublic = isPublicValue
        } else {
            isPublic = false
        }
        if let description = form.formRow(withTag: "description")?.value as? String,
            let filename = form.formRow(withTag: "filename")?.value as? String,
            let fileContent = form.formRow(withTag: "fileContent")?.value as? String {
            var files = [File]()
            if let file = File(aName: filename, aContent: fileContent) {
                files.append(file)
            }
            GitHubAPIManager.shared.createNewGist(description: description, isPublic: isPublic,
                                                          files: files, completionHandler: {
                                                            result in
                                                            guard result.error == nil, let successValue = result.value, successValue == true else {
                                                                    if let error = result.error {
                                                                        print(error)
                                                                    }
                                                                    let alertController = UIAlertController(title: "Could not create gist",
                                                                                                            message: "Sorry, your gist couldn't be deleted. " +
                                                                        "Maybe GitHub is down or you don't have an internet connection.",
                                                                                                            preferredStyle: .alert)
                                                                    // add ok button
                                                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                                    alertController.addAction(okAction)
                                                                    self.present(alertController, animated:true, completion: nil)
                                                                    return
                                                            }
                                                            self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
}
