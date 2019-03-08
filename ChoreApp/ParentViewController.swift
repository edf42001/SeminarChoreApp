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
    @IBOutlet weak var choresTableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var viewBot: NSLayoutConstraint!
    @IBOutlet weak var bot: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingButton1: NSLayoutConstraint!
    @IBOutlet weak var leadingButton2: NSLayoutConstraint!
    var enterChore:UIAlertController!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addChores: UIButton!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var choresButton: UIButton!
    @IBOutlet weak var dim: UIView!
    var memberMode = true
    @IBOutlet weak var closeMenu: UIButton!
    @IBOutlet weak var tableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        tableView.backgroundColor = Styles.backgroundColor
        settingsView.layer.cornerRadius = 10
        settingsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        settingsView.backgroundColor = UIColor.black
        settingsView.alpha = 0
        self.view.backgroundColor = Styles.backgroundColor
        addButton.applyButtonStyles(type: .standard)
        membersButton.applyButtonStyles(type: .standard)
        choresButton.applyButtonStyles(type: .standard)
        membersTableView.dataSource = self
        membersTableView.delegate = self
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
    
    //Add chore button pressed
    @IBAction func addChores(_ sender: UIButton) {
        self.present(enterChore, animated: true)
    }
    
    //Close settings menu
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        viewBot.constant = -409
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1
        })
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: {attempt in self.recede(attempt)})
        
    }
    
    func recede(_: Bool) -> Void {
        self.view.sendSubview(toBack: dim)
    }
    
    //Set mode to members
    @IBAction func setModeMember(_ sender: UIButton) {
        if memberMode == false {
            tableViewConstraint.constant += 691
            leadingButton1.constant += 691
            leadingButton2.constant += 691
        }
        memberMode = true
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
    }
    
    
    //Set mode to chores
    @IBAction func setModeChore(_ sender: UIButton) {
        if memberMode == true {
            tableViewConstraint.constant -= 691
            leadingButton1.constant -= 691
            leadingButton2.constant -= 691
        }
        memberMode = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
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
        return group?.children.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberNameCell", for: indexPath)
        cell.textLabel?.text = group?.children[indexPath.row].username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createChoreForUser(userIndex: indexPath.row)
    }
    
    //Add chore names later?
    func createChoreForUser(userIndex:Int){
        guard let asigneeUid = group?.children[userIndex].uid else {return}
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
        viewBot.constant = 0
        self.view.bringSubview(toFront: dim)
        self.view.bringSubview(toFront: settingsView)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.5
        })
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
    }
    
    //Send user group and user information to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNoGroup" {
            guard let destination = segue.destination as? NoGroupViewController else {return}
            destination.group = group
            destination.user = user
        }else if segue.identifier == "toAddMemberPopup" {
            guard let destination = segue.destination as? AddMemberPopupViewController else {return}
            destination.group = group
            destination.user = user
        }else if segue.identifier == "toAddChorePopup" {
            guard let destination = segue.destination as? AddChorePopupViewController else {return}
            destination.group = group
        }
    }
}
