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
    var group: Group?
    
    var toScreen = -1
    
    //Initialize everything
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        logInButton.applyButtonStyles(type: .standard)
        email.applyTextFieldStyles(type: .standard)
        password.applyTextFieldStyles(type: .standard)
        email.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
    }
    
    @IBAction func LogInButtonTouchedUp(_ sender: UIButton) {
        guard let eText = email.text else {return}
        guard let pText = password.text else {return}
        Auth.auth().signIn(withEmail: eText, password: pText) {(user, error) in
            if let user = user?.user, error == nil {
                guard let current = Auth.auth().currentUser else {return}
                guard let dName = current.displayName else {return}
                self.user = User(uid: current.uid, username: dName, email: eText, isParent: false)
                DatabaseHandler.readUserData(uid: user.uid, completion: {groupID, isParent in
                    if let groupID = groupID {
                        DatabaseHandler.readBasicGroupData(groupID: groupID, uid: user.uid, completion: {group, isParent in
                            self.group = group
                            if isParent {
                                print("User is parent")
                                self.user?.isParent = true
                                self.toScreen = 1
                                DatabaseHandler.getAllChoresFromGroup(groupID: groupID, completion: {chores in
                                    self.group?.chores = chores
                                    self.performSegue(withIdentifier: "toParent", sender: self)
                                })
                                
                            }else {
                                print("User is child")
                                self.user?.isParent = false
                                self.toScreen = 2
                                DatabaseHandler.getChoresForUser(uid: self.user!.uid, groupID: groupID, completion: {chores in
                                    self.user?.chores = chores
                                    self.performSegue(withIdentifier: "toChild", sender: self)
                                })
                            }
                        })
                    }else{
                        self.toScreen = 0
                        self.performSegue(withIdentifier: "toNoGroup", sender: self)
                    }
                })
            }else {
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
        switch toScreen {
        case 0:
            guard let destination = segue.destination as? NoGroupViewController else {return}
            destination.user = self.user
            destination.group = self.group
        case 1:
            guard let destination = segue.destination as? ParentViewController else {return}
            destination.user = self.user
            destination.group = self.group
        case 2:
            guard let destination = segue.destination as? ChildViewController else {return}
            destination.user = self.user
            destination.group = self.group
        default:
            print("error")
        }
    }

}
