//
//  SignUpViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var displayName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var user: User?
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        displayName.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
        ref = Database.database().reference()
    }
    
    @IBAction func signUpButtonTouchedUp(_ sender: UIButton) {
        guard let eText = email.text else {return}
        guard let dText = displayName.text else {return}
        guard let pText = password.text else {return}
        Auth.auth().createUser(withEmail: eText, password: pText) {(user, error) in
            if user != nil, error == nil {
                guard let current = user?.user else {return}
                self.user = User(uid: current.uid, username: dText, email: eText, isParent: false)
                self.addUser(username: dText, uid: current.uid, email: eText, ref: self.ref)
                self.performSegue(withIdentifier: "signUpToNoGroup", sender: self)
            }
            else {
                print(error?.localizedDescription)
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NoGroupViewController else {return}
        destination.user = self.user
    }
    
    func addUser(username:String, uid:String, email:String, ref:DatabaseReference){
        ref.child("users/\(uid)").setValue(["username":username,
                                            "email":email])
        ref.child("usernames/\(username)").setValue(uid)
    }

}
