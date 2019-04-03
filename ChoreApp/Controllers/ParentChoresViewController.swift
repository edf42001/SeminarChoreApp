//
//  ParentChoresViewController.swift
//  ChoreApp
//
//  Created by Benjamin Williamson (student LM) on 3/20/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ParentChoresViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user:User?
    var group:Group?
    var addedChores:[CustomChore] = [CustomChore(id: "xyz", name: "Do the thing please")]
    @IBOutlet weak var choreTable: UITableView!
    
    override func viewDidLoad() {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        self.view.backgroundColor = UIColor.black
        choreTable.dataSource = self
        choreTable.delegate = self
        choreTable.backgroundColor = UIColor.black
        choreTable.rowHeight = UITableViewAutomaticDimension
        choreTable.estimatedRowHeight = 600
        if let someMoreChores = group?.addedChores
        {
            addedChores = addedChores + (group?.addedChores)!
        }
        
        if ((user?.isParent)!) == false
        {
            DatabaseHandler.observeChores(groupID: group!.id) { (chores) in
                self.user?.chores! = chores
                self.choreTable.reloadData()
            }
        }
        choreTable.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((user?.isParent)!)
        {
            return addedChores.count
        }
        else
        {
            return (user?.chores?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if((user?.isParent)!)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "choreItem", for: indexPath) as! AssignableChore
            cell.choreLabel.text = addedChores[indexPath.row].name
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "assignedChore", for: indexPath) as! NewChoreTableViewCell
            cell.choreLabel.text = user?.chores![indexPath.row].name
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((user?.isParent)!) == false{
            let confirmationMessage = UIAlertController(title: "Please Confirm", message: choreTable.cellForRow(at: indexPath)?.textLabel?.text, preferredStyle: .alert)
            confirmationMessage.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
            confirmationMessage.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                let cell = tableView.cellForRow(at: indexPath) as! ChoreTableViewCell
                DatabaseHandler.removeChore(asigneeUid: self.user!.uid, choreID: cell.choreID!, groupID: self.group!.id)
                self.choreTable.reloadData()
            
            }))
            self.present(confirmationMessage, animated: true)
        }
    }
    
    
    

    
    
    
    
}
