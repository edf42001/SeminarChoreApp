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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        signUpButton.applyButtonStyles(type: .standard)
        email.applyTextFieldStyles(type: .standard)
        displayName.applyTextFieldStyles(type: .standard)
        password.applyTextFieldStyles(type: .standard)
        email.delegate = self
        displayName.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
    }
    
    //Create a user with the specifications entered by the user, and send the data to the database. Also, send the user to the NoGroupViewController
    @IBAction func signUpButtonTouchedUp(_ sender: UIButton) {
        guard let eText = email.text else {return}
        guard let dText = displayName.text else {return}
        guard let pText = password.text else {return}
        Auth.auth().createUser(withEmail: eText, password: pText) {(user, error) in
            if user != nil, error == nil {
                guard let current = user?.user else {return}
                let changeRequest = current.createProfileChangeRequest()
                changeRequest.displayName = dText
                changeRequest.commitChanges(completion: {error in
                    print("Change username error: \(error)")
                })
                self.user = User(uid: current.uid, username: dText, email: eText, isParent: false)
                DatabaseHandler.addUser(username: dText, uid: current.uid, email: eText)
                self.navigationController?.isNavigationBarHidden = true
                self.performSegue(withIdentifier: "toTabBar", sender: self)
            }
            else {
                print("Create user error: \(error?.localizedDescription)")
            }
        }
    }
    
    //Smooth transitions between the text input boxes
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
    
    //Send user data to the NoGroupViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let destination = segue.destination as? NoGroupViewController else {return}
//        destination.user = self.user
        let destination = segue.destination as! CustomTabBarController
        destination.user = user
        destination.group = nil
    }

}
