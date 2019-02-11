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
    var enterGroupName:UIAlertController!
    var toScreen = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEnterGroupNameAlert()
    
        if Auth.auth().currentUser==nil {
            let email = "ethan@me.com"
            let password = "passwordpassword"
            Auth.auth().createUser(withEmail: email, password: password, completion: nil)
        }
        
        //FOR TESTING PURPOSES Setup user and group objects for next controller
        if let uid = Auth.auth().currentUser?.uid {
            user = User(uid: uid, username: "bobisthebest", email: "ethan@me.com", isParent: true)
//            user?.groupID = "-LVE5XGJ5ZNvT-ZnnJZ0"
//            let emptyUserArray:[UserInfo] = []
            
//            group = Group(id: "-LVE5XGJ5ZNvT-ZnnJZ0", name: "Groooup", parents: emptyUserArray, children: emptyUserArray, chores: nil)
            DatabaseHandler.observeIfAddedToGroup(uid: uid, onRecieve: {groupID in
                if let groupID = groupID as? String {
                    DatabaseHandler.readBasicGroupData(groupID: groupID, uid: self.user!.uid, completion: {group, isParent in
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
       
        //End for testing purposes
    }
    
    //Also only for testing purposes
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //The user clicks the button
    @IBAction func createGroupButtonPressed(_ sender: UIButton) {
        self.present(enterGroupName, animated: true)
    }
    
    func createNewGroup(name: String){
        if let uid = user?.uid {
            DatabaseHandler.createGroup(uid: uid, name: name) {key in
                guard let user = self.user else {return}
                user.groupID = key
                user.isParent = true
                let parent:[UserInfo] = [UserInfo(uid: user.uid, username:user.username, isParent:true)]
                self.group = Group(id: key, name: name, parents: parent, children: [], chores: nil)
                self.performSegue(withIdentifier: "toParent", sender: self)
            }
        }
    }
    
    func setupEnterGroupNameAlert() {
        enterGroupName = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            self.enterGroupName.dismiss(animated: true)
        })
        let createGroupAction = UIAlertAction(title: "Create", style: .default, handler: {action in
            let nameTextField = self.enterGroupName.textFields![0] as UITextField
            var name = "My Group"
            if let text = nameTextField.text, text != "" {
                name = text
            }else{
                
            }
            
            self.createNewGroup(name: name) //create the new group
            
            self.enterGroupName.dismiss(animated: true)
        })
        enterGroupName.addAction(cancelAction)
        enterGroupName.addAction(createGroupAction)
        enterGroupName.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "My Group"
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
            print("error")
        }
    }
    

}
