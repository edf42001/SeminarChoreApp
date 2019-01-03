//
//  NoGroupViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/17/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NoGroupViewController: UIViewController {
    var user:User?
    var group:Group?
    var enterGroupName:UIAlertController!
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        setupEnterGroupNameAlert()
    
        if Auth.auth().currentUser==nil {
            let email = "ethan@me.com"
            let password = "passwordpassword"
            Auth.auth().createUser(withEmail: email, password: password, completion: nil)
        }
        
        //FOR TESTING PURPOSES Setup user and group objects for next controller
        if let uid = Auth.auth().currentUser?.uid {
            user = User(uid: uid, username: "bobisthebest", email: "ethan@me.com", isParent: true)
            user?.groupID = "-LVE5XGJ5ZNvT-ZnnJZ0"
            var members:[UserInfo] = [UserInfo(uid: "", username: "", isParent: true)]
            let handle = ref.child("groups/-LVE5XGJ5ZNvT-ZnnJZ0/members").observe(.value, with: {snapshot in
                if let membersData = snapshot.value as? [String:String] {
                    for uid in membersData.keys {
                        let handle2 = self.ref.child("/users/\(uid)/username").observe(.value, with: {snapshot in
                            if let usernameData = snapshot.value as? String{
                                let member = UserInfo(uid: uid, username: usernameData, isParent: membersData[uid] == "parent")
                                members.append(member)
                            }
                        })
                        self.ref.removeObserver(withHandle: handle2)
                    }
                }else{
                    print("nope")
                }
            })
            ref.removeObserver(withHandle: handle)
            print(members)
            group = Group(id: "-LVE5XGJ5ZNvT-ZnnJZ0", name: "Groooup", members: members, chores: nil)
        }
        //End for testing purposes
    }
    //Also only for testing purposes
    override func viewDidAppear(_ animated: Bool) {
        print(group?.members)
        self.performSegue(withIdentifier: "toParentViewController", sender: self)
    }
    
    //The user clicks the button
    @IBAction func createGroupButtonPressed(_ sender: UIButton) {
        self.present(enterGroupName, animated: true)
    }
    
    func createNewGroup(name: String){
        if let uid = Auth.auth().currentUser?.uid {
            createGroupInDatabase(uid: uid, name: name, ref: ref, completion: {key in
                guard let user = self.user else {return}
                user.groupID = key
                user.isParent = true
                let members:[UserInfo] = [UserInfo(uid: user.uid, username:user.username, isParent:true)]
                self.group = Group(id: key, name: name, members: members, chores: nil)
                self.performSegue(withIdentifier: "toParentViewController", sender: self)
            })
        }
    }
    
    func createGroupInDatabase(uid:String, name:String, ref:DatabaseReference,completion: @escaping (String)->()){
        let key = ref.child("groups").childByAutoId().key ?? ""
        ref.child("groups/\(key)").setValue(["name":name,
                                             "members":[uid:true]])
        ref.child("users/\(uid)/group").setValue(key, withCompletionBlock: {error, ref in
            completion(key)
        })
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
        guard let destination = segue.destination as? ParentViewController else {return}
        destination.user = user
        destination.group = group
    }
    

}
