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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                            DatabaseHandler.getAllCustomChoresFromGroup(groupID: groupID, completion: { (addedChores) in
                                self.group?.addedChores = addedChores
                            })
                            if isParent {
                                print("User is parent")
                                self.user?.isParent = true
                                self.toScreen = 1
                                DatabaseHandler.getAllChoresFromGroup(groupID: groupID, completion: {chores in
                                    self.group?.chores = chores
                                    self.navigationController?.isNavigationBarHidden = true
                                    self.performSegue(withIdentifier: "toTabBar", sender: self)
                                })
                                
                            }else {
                                print("User is child")
                                self.user?.isParent = false
                                self.toScreen = 2
                                DatabaseHandler.getChoresForUser(uid: self.user!.uid, groupID: groupID, completion: {chores in
                                    self.user?.chores = chores
                                    self.navigationController?.isNavigationBarHidden = true
                                    self.performSegue(withIdentifier: "toTabBar", sender: self)
                                })
                            }
                        })
                    }else{
                        self.toScreen = 0
                        self.navigationController?.isNavigationBarHidden = true
                        self.performSegue(withIdentifier: "toTabBar", sender: self)
                    }
                })
            }else {
                print(error?.localizedDescription)
            }
        }
    }
    
    //Smooth transitions between the text input boxes
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
    
    //Send user and group information to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CustomTabBarController
        destination.user = user
        destination.group = group
//        switch toScreen {
//        case 0:
//            guard let destination = segue.destination as? NoGroupViewController else {return}
//            destination.user = self.user
//            destination.group = self.group
//        case 1:
//            guard let destination = segue.destination as? ParentViewController else {return}
//            destination.user = self.user
//            destination.group = self.group
//        case 2:
//            guard let destination = segue.destination as? ChildViewController else {return}
//            destination.user = self.user
//            destination.group = self.group
//        default:
//            print("error")
//        }
    }

}
