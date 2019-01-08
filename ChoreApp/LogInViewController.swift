//
//  LogInViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    var user: User?
    
    //Initialize everything
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
    }
    
    @IBAction func LogInButtonTouchedUp(_ sender: UIButton) {
        guard let eText = email.text else {return}
        guard let pText = password.text else {return}
        Auth.auth().signIn(withEmail: eText, password: pText) {(user, error) in
            if user != nil, error == nil {
                guard let current = Auth.auth().currentUser else {return}
                guard let dName = current.displayName else {return}
                self.user = User(uid: current.uid, username: dName, email: eText, isParent: false)
                self.performSegue(withIdentifier: "logInToHome", sender: self)
            }
            else {
                print(error?.localizedDescription)
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ViewController else {return}
        destination.user = self.user
    }

}
