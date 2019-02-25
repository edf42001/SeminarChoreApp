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
    let move = CGFloat(175)
    var enterMemberNameAlert:UIAlertController!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var addMemberButton: UIButton!
    var menuOpen = false
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var addChore: UIButton!
    var enterMember:UIAlertController!
    var enterChore:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.tabColor
        background.backgroundColor = Styles.backgroundColor
        addMemberButton.applyButtonStyles(type: .standard)
        setupEnterMemberNameAlert()
        membersTableView.dataSource = self
        membersTableView.delegate = self
        addMemberButton.applyButtonStyles(type: .alternateBig)
        addChore.applyButtonStyles(type: .standard)
        addMemberButton.applyButtonStyles(type: .standard)
        setupEnterMemberNameAlert()
        setupEnterChoreAlert()
        DatabaseHandler.observeChores(groupID: group!.id, completion: {chores in
            self.group?.chores = chores
        })
        DatabaseHandler.observeMembersInGroup(groupID: group!.id, completion: {parents, children in
            self.group?.parents = parents
            self.group?.children = children
            self.membersTableView.reloadData()
        })
    }
    
    //Present the popup to ask for the member's name if one wishes to add a new member
    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
        self.present(enterMemberNameAlert, animated: true)
    }
    
    //Present the popup to ask for details should the user want to create a new chore
    @IBAction func addChoreButtonPressed(_ sender: UIButton) {
        self.present(enterChore, animated: true)
    }
    
    //Leave the current group
    @IBAction func leaveGroupButtonPressed(_ sender: UIButton) {
        guard let uid = user?.uid, let groupID = group?.id else {return}
        DatabaseHandler.stopObservingChores()
        DatabaseHandler.stopObservingMembersInGroup()
        DatabaseHandler.leaveGroup(uid: uid, groupID: groupID, isParent: user!.isParent, done: {
            self.user?.groupID = nil
            self.group = nil
            self.performSegue(withIdentifier: "toNoGroup", sender: self)
        })
        
    }
    
    //Setup the popup in order to add a new member, and ask for the member's username
    func setupEnterMemberNameAlert() {
        //Create the title
        enterMemberNameAlert = UIAlertController(title: "Enter Member Name", message: nil, preferredStyle: .alert)
        //Create the "cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            self.enterMemberNameAlert.dismiss(animated: true)
        })
        //Create the "add" button
        let createMemberAction = UIAlertAction(title: "Add", style: .default, handler: {action in
            let nameTextField = self.enterMemberNameAlert.textFields![0] as UITextField
            var name:String?
            if let text = nameTextField.text, text != "" {
                name = text
            }
            //Search the database for the username
            if let name = name, let groupID = self.group?.id {
                DatabaseHandler.tryAddMemberToGroup(groupID: groupID, newMemberUserName: name, asParent: true, completition: {uid, error in
                    if let uid = uid {
                        self.group?.parents?.append(UserInfo(uid: uid, username: name, isParent: true))
                        self.enterMemberNameAlert.dismiss(animated: true)
                        self.membersTableView.reloadData()
                    }else{
                       print(error!)
                    }
                })
            }
        })
        //Add pieces to the alert
        enterMemberNameAlert.addAction(cancelAction)
        enterMemberNameAlert.addAction(createMemberAction)
        enterMemberNameAlert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter Username"
        })
    }
    
    //Setup the popup in order to add a new chore, and ask for all the necessary details
    func setupEnterChoreAlert() {
        enterChore = UIAlertController(title: "Enter Chore Name", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {action in
            self.enterChore.dismiss(animated: true)
        })
        let createChoreAction = UIAlertAction(title: "Create", style: .default, handler: {action in
            let choreTextField = self.enterChore.textFields![0] as UITextField
            //Might want to incorporate the 'chore' variable in the future
            var chore = "My Chore"
            if let text = choreTextField.text, text != "" {
                chore = text
            }
            self.createChoreForUser(userIndex: 0) //Update to correct user later, and add chore properties, such as name, date, etc.
            self.enterChore.dismiss(animated: true)
        })
        enterChore.addAction(cancelAction)
        enterChore.addAction(createChoreAction)
        enterChore.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "A Chore"
        })
    }

    //Tableview functions
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
    
    //Add chore names later?
    func createChoreForUser(userIndex:Int){
        guard let asigneeUid = group?.children?[userIndex].uid else {return}
        //Create the title
        let enterChoreAlert = UIAlertController(title: "Chore Name:", message: nil, preferredStyle: .alert)
        //Create the "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            enterChoreAlert.dismiss(animated: true)
        })
        //Create the "Create" button
        let createChoreAction = UIAlertAction(title: "Create", style: .default, handler: {action in
            let nameTextField = enterChoreAlert.textFields![0] as UITextField
            guard let name = nameTextField.text else {return}
            if name != "" {
                DatabaseHandler.addChore(name: name, asigneeUid: asigneeUid, groupID: self.group!.id, completion: {id in
                     self.group?.chores?.append(Chore(id: id, name: name, asigneeID: asigneeUid))
                })
            }
        })
        //Add specified items to the popup
        enterChoreAlert.addAction(cancelAction)
        enterChoreAlert.addAction(createChoreAction)
        enterChoreAlert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter Username"
        })
        self.present(enterChoreAlert, animated: true, completion: nil)
    }
    
    //Open the settings tab
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
    
    //Send user group and user information to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NoGroupViewController else {return}
        destination.group = group
        destination.user = user
    }

}
