//
//  NoGroupViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/17/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit
import Firebase

class NoGroupViewController: UIViewController {
    var user:User?
    var group:Group?
    var toScreen = -1
    var menuOpen = false
    
    @IBOutlet weak var createGroupButton: UIButton!
    
    override func viewDidLoad() {
        toScreen = -1
        super.viewDidLoad()
//        self.view.backgroundColor = Styles.tabColor
//        background.backgroundColor = Styles.backgroundColor
        createGroupButton.applyButtonStyles(type: .standard)
        DatabaseHandler.observeIfAddedToGroup(uid: user!.uid, onRecieve: {groupID in
            if let groupID = groupID as? String, self.toScreen == -1{
                DatabaseHandler.readBasicGroupData(groupID: groupID, uid: self.user!.uid, completion: {group, isParent in
                    print("\(groupID), \(isParent)")
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
                    DatabaseHandler.stopObservingIfAddedToGroup()
                })
            }
        })
    }

    // MARK: - Navigation

    //Transfer the user's information to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch toScreen {
        case 1:
            guard let destination = segue.destination as? ParentViewController else {return}
            destination.user = self.user
            destination.group = self.group
        case 2:
            guard let destination = segue.destination as? ChildViewController else {return}
            destination.user = self.user
            destination.group = self.group
        default:
            if segue.identifier == "toCreateGroupPopup"{
                guard let destination = segue.destination as? CreateNewGroupViewController else {return}
                destination.user = self.user
                destination.group = self.group
                destination.onClose = {created in
                    if created {
                        self.toScreen = 1
                        self.performSegue(withIdentifier: "toParent", sender: self)
                    }
                }
            }else{
                print("Failed segue error")
            }
        }
    }
    

}