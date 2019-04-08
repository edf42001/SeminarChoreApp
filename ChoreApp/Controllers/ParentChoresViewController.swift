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
//        self.view.backgroundColor = UIColor.black
        choreTable.dataSource = self
        choreTable.delegate = self
//        choreTable.backgroundColor = UIColor.black
        choreTable.rowHeight = UITableViewAutomaticDimension
//        choreTable.estimatedRowHeight = 600
//        addedChores = addedChores + (group?.addedChores)!
//        if ((user?.isParent)!) == false
//        {
//            DatabaseHandler.observeChores(groupID: group!.id) { (chores) in
//                self.user?.chores! = chores
//                self.choreTable.reloadData()
//            }
//        }
        
        loadData()
    }
    
    func loadData() {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        print("does this even run")
        self.choreTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user!.isParent {
            return ChoreType.total.rawValue - 1 // addedChores.count
        }else{
            print(user!.chores?.count)
            return user!.chores?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if user!.isParent
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "choreItem", for: indexPath) as! AssignableChore
            cell.choreLabel.text = Chore.choreNames[indexPath.row]
            cell.iconImage.image = Chore.getChoreImage(choreType: ChoreType(rawValue: indexPath.row)!)
            cell.iconImage.layer.cornerRadius = 8
            cell.iconImage.layer.masksToBounds = true
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "assignedChore", for: indexPath) as! NewChoreTableViewCell
            print(indexPath.row)
            print(user?.chores![indexPath.row].choreType.rawValue ?? 8)
            print(user?.chores![indexPath.row].choreType)
            cell.choreLabel.text = Chore.choreNames[user?.chores![indexPath.row].choreType.rawValue ?? 8]
            cell.choreID = user?.chores![indexPath.row].id
            cell.iconImage.image = Chore.getChoreImage(choreType: (user?.chores![indexPath.row].choreType)!)
            cell.iconImage.layer.cornerRadius = 8
            cell.iconImage.layer.masksToBounds = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if((user?.isParent)!) == false{
            DispatchQueue.main.async{
                let confirmationMessage = UIAlertController(title: "Please Confirm", message: self.choreTable.cellForRow(at: indexPath)?.textLabel?.text, preferredStyle: .alert)
            confirmationMessage.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            confirmationMessage.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                let cell = tableView.cellForRow(at: indexPath) as! NewChoreTableViewCell
                DatabaseHandler.removeChore(asigneeUid: self.user!.uid, choreID: cell.choreID!, groupID: self.group!.id)
            }))
            self.present(confirmationMessage, animated: true)
            
            }
            choreTable.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assignChore" {
            if let destination = segue.destination as? AssignChoreViewController {
                if let indexPath = choreTable.indexPathForSelectedRow {
                    destination.chore = Chore(id: "", name: "", asigneeID: "", choreType: ChoreType(rawValue: indexPath.row)!)
                }
            }
        }
    }
}
