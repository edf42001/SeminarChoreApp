//
//  ParentViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/17/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user:User?
    var group:Group?
    
    var enterMemberNameAlert:UIAlertController!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var asParentSwitch: UISwitch!
    @IBOutlet weak var addMemberButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEnterMemberNameAlert()
        membersTableView.dataSource = self
        membersTableView.delegate = self
        addMemberButton.applyButtonStyles(type: .alternateBig)
        
        DatabaseHandler.observeChores(groupID: group!.id, completion: {chores in
            self.group?.chores = chores
            print(chores)
        })
        
        DatabaseHandler.observeMembersInGroup(groupID: group!.id, completion: {parents, children in
            self.group?.parents = parents
            self.group?.children = children
            self.membersTableView.reloadData()
        })
    }
    
    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
        self.present(enterMemberNameAlert, animated: true)
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: UIButton) {
        guard let uid = user?.uid, let groupID = group?.id else {return}
        DatabaseHandler.leaveGroup(uid: uid, groupID: groupID)
        DatabaseHandler.stopObservingChores()
        DatabaseHandler.stopObservingMembersInGroup()
        user?.groupID = nil
        group = nil
        self.performSegue(withIdentifier: "toNoGroup", sender: self)
    }
    
    func setupEnterMemberNameAlert() {
        enterMemberNameAlert = UIAlertController(title: "Enter Member Name", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            self.enterMemberNameAlert.dismiss(animated: true)
        })
        
        let createMemberAction = UIAlertAction(title: "Add", style: .default, handler: {action in
            let nameTextField = self.enterMemberNameAlert.textFields![0] as UITextField
            var name:String?
            if let text = nameTextField.text, text != "" {
                name = text
            }
            
            if let name = name, let groupID = self.group?.id {
                let asParent = self.asParentSwitch.isOn
                DatabaseHandler.tryAddMemberToGroup(groupID: groupID, newMemberUserName: name, asParent: asParent, completition: {uid in
                    if let uid = uid {
                        print("New member is parent? \(asParent)")
                        if asParent {
                            self.group?.parents?.append(UserInfo(uid: uid, username: name, isParent: true))
                        }else{
                            self.group?.children?.append(UserInfo(uid: uid, username: name, isParent: false))
                        }
                        self.enterMemberNameAlert.dismiss(animated: true)
                        self.membersTableView.reloadData()
                    }else{
                       print("No user with that username")
                    }
                })
            }
        })
        
        enterMemberNameAlert.addAction(cancelAction)
        enterMemberNameAlert.addAction(createMemberAction)
        enterMemberNameAlert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter Username"
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.children?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberNameCell", for: indexPath)
        cell.textLabel?.text = group?.children?[indexPath.row].username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createChoreForUser(userIndex: indexPath.row)
    }
    
    func createChoreForUser(userIndex:Int){
        guard let asigneeUid = group?.children?[userIndex].uid else {return}
        
        let enterChoreAlert = UIAlertController(title: "Chore Name:", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            enterChoreAlert.dismiss(animated: true)
        })
        
        let createChoreAction = UIAlertAction(title: "Create", style: .default, handler: {action in
            let nameTextField = enterChoreAlert.textFields![0] as UITextField
            guard let name = nameTextField.text else {return}
            if name != "" {
                DatabaseHandler.addChore(name: name, asigneeUid: asigneeUid, groupID: self.group!.id, completion: {id in
                     self.group?.chores?.append(Chore(id: id, name: name, asigneeID: asigneeUid))
                })
            }
        })
        
        enterChoreAlert.addAction(cancelAction)
        enterChoreAlert.addAction(createChoreAction)
        enterChoreAlert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter Username"
        })
        
        self.present(enterChoreAlert, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destination = segue.destination as? NoGroupViewController else {return}
        destination.group = group
        destination.user = user
    }

}
