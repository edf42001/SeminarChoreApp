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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: Any) {
        DatabaseHandler.stopObservingChores()
        guard let uid = user?.uid, let groupID = group?.id else {return}
        DatabaseHandler.leaveGroup(uid: uid, groupID: groupID, isParent: false, done:{
            self.user?.groupID = nil
            self.group = nil
            self.performSegue(withIdentifier: "toNoGroupController", sender: self)
        })
        
    }
    
    
    
}
