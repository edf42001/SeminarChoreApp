//
//  ChildViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/17/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    var user:User?
    var group:Group?
    var ref:DatabaseReference!
    var choreList: [Chore] = []
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var choreTable: UITableView!
    @IBOutlet weak var groupLabel: UILabel!
    var menuOut = false;
    @IBOutlet weak var backgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        choreTable.dataSource = self
        choreTable.delegate = self
        background.backgroundColor = Styles.backgroundColor
        groupLabel.text = group!.name
        // Do any additional setup after loading the view.
        DatabaseHandler.observeChores(groupID: group!.id) { (chores) in
            self.user?.chores! = chores
            self.choreTable.reloadData()
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        if menuOut == true
        {
            backgroundBottomConstraint.constant = 0
            backgroundTopConstraint.constant = 0
            menuOut = false
        }
        else
        {
            backgroundBottomConstraint.constant = 200
            backgroundTopConstraint.constant = -200
            menuOut = true
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.chores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // choreList = (user?.chores!)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreCell", for: indexPath) as! ChoreTableViewCell
        cell.choreLabel.text = user?.chores![indexPath.row].name
        cell.choreID = user?.chores![indexPath.row].id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let confirmationMessage = UIAlertController(title: "Please Confirm", message: choreTable.cellForRow(at: indexPath)?.textLabel?.text, preferredStyle: .alert)
        confirmationMessage.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        confirmationMessage.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            let cell = tableView.cellForRow(at: indexPath) as! ChoreTableViewCell
            DatabaseHandler.removeChore(asigneeUid: self.user!.uid, choreID: cell.choreID!, groupID: self.group!.id)
            self.choreTable.reloadData()

        }))
        self.present(confirmationMessage, animated: true)
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: UIButton) {
        DatabaseHandler.stopObservingChores()
        guard let uid = user?.uid, let groupID = group?.id else {return}
        DatabaseHandler.leaveGroup(uid: uid, groupID: groupID, isParent: false, done:{
            self.user?.groupID = nil
            self.group = nil
            self.performSegue(withIdentifier: "toNoGroup", sender: self)
        })
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NoGroupViewController {
            destination.user = user
            destination.group = group
        }
     }
    
    
    
}
