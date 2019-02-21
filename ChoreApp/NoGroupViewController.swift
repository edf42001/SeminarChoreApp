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
    let move = CGFloat(175)
    var user:User?
    var group:Group?
    var enterGroupName:UIAlertController!
    var toScreen = -1
    var menuOpen = false
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var createGroupButton: UIButton!
    
    override func viewDidLoad() {
        toScreen = -1
        super.viewDidLoad()
        self.view.backgroundColor = Styles.tabColor
        background.backgroundColor = Styles.backgroundColor
        createGroupButton.applyButtonStyles(type: .standard)
        
        setupEnterGroupNameAlert()

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
    
    @IBAction func openSettings(_ sender: UIButton) {
        if !menuOpen {
            leading.constant -= move
            trailing.constant += move
        }
        else {
            leading.constant += move
            trailing.constant -= move
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
        menuOpen = !menuOpen
    }
    
    
    //The user clicks the button
    @IBAction func createGroupButtonPressed(_ sender: UIButton) {
        self.present(enterGroupName, animated: true)
    }
    
    func createNewGroup(name: String){
        if let uid = user?.uid {
            DatabaseHandler.stopObservingIfAddedToGroup()
            DatabaseHandler.createGroup(uid: uid, name: name) {key in
                guard let user = self.user else {return}
                user.groupID = key
                user.isParent = true
                let parent:[UserInfo] = [UserInfo(uid: user.uid, username:user.username, isParent:true)]
                self.group = Group(id: key, name: name, parents: parent, children: [], chores: nil)
                self.toScreen = 1
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
            print("Failed segue error")
        }
    }
    

}
