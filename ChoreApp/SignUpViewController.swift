//
//  SignUpViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var displayName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        displayName.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if email.isFirstResponder {
            displayName.becomeFirstResponder()
        }
        else if displayName.isFirstResponder {
            password.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
            password.resignFirstResponder()
        }
        return true
    }
    

}
