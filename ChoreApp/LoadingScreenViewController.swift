//
//  LoadingScreenViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/11/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class LoadingScreenViewController: UIViewController {

    var user: User?
    
    var toScreen = -1
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if let user = Auth.auth().currentUser  {
            self.user = User(uid: user.uid, username: user.displayName ?? "", email: user.email ?? "", isParent: false)
            ref.child("users/\(user.uid)/group").observeSingleEvent(of: .value, with: {snapshot in
                if let groupID = snapshot.value as? String {
                    self.user?.groupID = groupID
                }
                else {
                    self.toScreen = 0
                    self.performSegue(withIdentifier: "toNoGroup", sender: self)
                }
            })
            ref.child("groups/\(self.user?.groupID)/members/\(self.user?.uid)").observeSingleEvent(of: .value, with: {snapshot in
                if let parentalStatus = snapshot.value as? String {
                    if parentalStatus == "child" {
                        self.user?.isParent = false
                        self.toScreen = 2
                        self.performSegue(withIdentifier: "toChild", sender: self)
                    }
                    else if parentalStatus == "parent" {
                        self.user?.isParent = true
                        self.toScreen = 1
                        self.performSegue(withIdentifier: "toParent", sender: self)
                    }
                }
            })
        }
        else {
            toScreen = 3
            self.performSegue(withIdentifier: "toStart", sender: self)
        }
        // Do any additional setup after loading the view.
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
        default:
            //No error if meant to go to the starting screen
            if toScreen != 3 {
                print("error")
            }
        }
    }

}
