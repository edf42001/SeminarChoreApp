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
//        //Testing code
//        if Auth.auth().currentUser != nil {
//            Auth.auth().createUser(withEmail: "me@me.com", password: "password")
//        }
//        do{
//            try Auth.auth().signOut()
//        }catch{let _:NSError
//
//        }
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
        }
        else {
            print("User does not exist")
            toScreen = 3
            self.performSegue(withIdentifier: "toStartingScreen", sender: self)
        }
    }
    
    //Sending the gathered user data to the desired destination
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
        case 3:
            break
        default:
            print("error")
        }
    }

}
