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
                }
            })
            ref.child("groups/\(self.user?.groupID ?? "0")/members/\(self.user?.uid ?? "0")").observeSingleEvent(of: .value, with: {snapshot in
                if let parentalStatus = snapshot.value as? String {
                    if parentalStatus == "child" {
                        self.user?.isParent = false
                        self.toScreen = 2
                    }
                    else if parentalStatus == "parent" {
                        self.user?.isParent = true
                        self.toScreen = 1
                    }
                }
            })
        }
        else {
            toScreen = 3
        }
        // Do any additional setup after loading the view.
    }
    

}
