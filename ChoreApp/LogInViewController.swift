//
//  LogInViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    //Initialize everything
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
    }
    
    @IBAction func LogInButtonTouchedUp(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if email.isFirstResponder {
            password.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
            password.resignFirstResponder()
        }
        return true
    }
    

}
