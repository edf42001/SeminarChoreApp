//
//  DuplicateStartingScreenViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/31/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DuplicateLoadingScreenViewController: UIViewController {
    var user: User?
    
    var toScreen = -1
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
            Auth.auth().createUser(withEmail: "me@me.com", password: "password")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser  {
            print("User Exists")
            print(user.uid)
            print(user.email)
            self.user = User(uid: user.uid, username: user.displayName ?? "", email: user.email ?? "", isParent: false)
            ref.child("users/\(user.uid)/group").observeSingleEvent(of: .value, with: {snapshot in
                if let groupID = snapshot.value as? String {
                    print("User has group")
                    self.user?.groupID = groupID
                    self.ref.child("groups/\(self.user?.groupID ?? "0")/members/\(self.user?.uid ?? "0")").observeSingleEvent(of: .value, with: {snapshot in
                        if let parentalStatus = snapshot.value as? String {
                            if parentalStatus == "child" {
                                print("User is child")
                                self.user?.isParent = false
                                self.toScreen = 2
                                self.performSegue(withIdentifier: "toChild", sender: self)
                            }
                            else if parentalStatus == "parent" {
                                print("User is parent")
                                self.user?.isParent = true
                                self.toScreen = 1
                                self.performSegue(withIdentifier: "toParent", sender: self)
                            }
                        }
                    })
                }
                else {
                    self.toScreen = 0
                    self.performSegue(withIdentifier: "toNoGroup", sender: self)
                }
            })
        }
        else {
            print("User does not exist")
            toScreen = 3
            self.performSegue(withIdentifier: "toStartingScreen", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch toScreen {
        case 0:
            guard let destination = segue.destination as? NoGroupViewController else {return}
            destination.user = self.user
        case 1:
            guard let destination = segue.destination as? ParentViewController else {return}
            destination.user = self.user
        case 2:
            guard let destination = segue.destination as? ChildViewController else {return}
            destination.user = self.user
        case 3:
            break
        default:
            print("error")
        }
    }

}
