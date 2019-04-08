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
    var group: Group?
    var toScreen = -1
    var ref: DatabaseReference!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Attempting to load and use the current user's information to send him/her to the appropriate landing page
        if let user = Auth.auth().currentUser {
            print("User Exists")
            print(user.uid)
            print(user.email)
            print(user.displayName)
            self.user = User(uid: user.uid, username: user.displayName ?? "", email: user.email ?? "", isParent: false)
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
                                self.performSegue(withIdentifier: "toTabBar", sender: self)
                            })
                            
                        }else {
                            print("User is child")
                            self.user?.isParent = false
                            self.toScreen = 2
                            DatabaseHandler.getChoresForUser(uid: self.user!.uid, groupID: groupID, completion: {chores in
                                self.user?.chores = chores
                                self.performSegue(withIdentifier: "toTabBar", sender: self)
                            })
                        }
                    })
                }else{
                    self.toScreen = 0
                    self.performSegue(withIdentifier: "toTabBar", sender: self)
                }
            })
        }
        else {
            print("User does not exist")
            toScreen = 3
            self.performSegue(withIdentifier: "toStartingScreen", sender: self)
        }
    }
    
    //Sending the gathered user data to the desired destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if toScreen != 3 {
            let destination = segue.destination as! CustomTabBarController
            destination.user = user
            destination.group = group
        }
    }
}
