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
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var leaveGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        tableView.backgroundColor = Styles.backgroundColor
        settingsView.layer.cornerRadius = 40
        settingsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dim.backgroundColor = UIColor.black
        dim.alpha = 0
        settingsView.backgroundColor = UIColor.black
        settingsView.alpha = 1
        self.view.backgroundColor = Styles.backgroundColor
        addButton.applyButtonStyles(type: .standard)
        addChores.applyButtonStyles(type: .standard)
        membersButton.applyButtonStyles(type: .standard)
        choresButton.applyButtonStyles(type: .standard)
        membersTableView.dataSource = self
        membersTableView.delegate = self
        groupName.textColor = UIColorFromRGB(0xD3E1DF)
        groupName.text = self.group?.name
        leaveGroupButton.applyButtonStyles(type: .settings)
        
        DatabaseHandler.observeChores(groupID: group!.id, completion: {chores in
            self.group?.chores = chores
        })
        
        DatabaseHandler.observeMembersInGroup(groupID: group!.id, completion: {parents, children in
            self.group?.parents = parents
            self.group?.children = children
            self.membersTableView.reloadData()
        })
    }
    
    
    //Close settings menu
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        viewBot.constant = -409
        UIView.animate(withDuration: 0.3, animations: {
            self.dim.alpha = 0
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

    //Tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.children.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberNameCell", for: indexPath)
        cell.textLabel?.text = group?.children[indexPath.row].username
        
        return cell
    }
    
    //Open the settings tab
    @IBAction func openSettings(_ sender: UIButton) {
        viewBot.constant = 0
        self.view.bringSubview(toFront: dim)
        self.view.bringSubview(toFront: settingsView)
        UIView.animate(withDuration: 0.3, animations: {
            self.dim.alpha = 0.4
        })
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
    }
    
    //Send user group and user information to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNoGroup" {
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
