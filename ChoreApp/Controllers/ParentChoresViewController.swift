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
    var hasChores:DarwinBoolean = false
    var user:User?
    var group:Group?
    var addedChores:[CustomChore] = [CustomChore(id: "xyz", name: "Do the thing please")]
    @IBOutlet weak var choreTable: UITableView!
    
    override func viewDidLoad() {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        if let choreCount = user!.chores?.count
        {
            if choreCount != 0 || user?.isParent == true
            {
                hasChores = true
            }
            else
            {
                hasChores = false
            }
        }
        else if user?.isParent == false
        {
            hasChores = false
        }
        else
        {
            hasChores = true
        }
        
        choreTable.dataSource = self
        choreTable.delegate = self
        choreTable.rowHeight = UITableViewAutomaticDimension
        
//        addedChores = addedChores + (group?.addedChores)!
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = choreTable.indexPathForSelectedRow{
            choreTable.deselectRow(at: index, animated: true)
        }
    }
    
    func loadData() {

        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        if let choreCount = user!.chores?.count
        {
            if choreCount != 0 || user?.isParent == true
            {
                hasChores = true
            }
            else
            {
                hasChores = false
            }
        }
        else if user?.isParent == false
        {
            hasChores = false
        }
        else
        {
            hasChores = true
        }
        if hasChores == true {
            choreTable.separatorStyle = .singleLine
            choreTable.allowsSelection = true
        }else{
            choreTable.separatorStyle = .none
            choreTable.allowsSelection = false
        }
        
        self.choreTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasChores == true
        {
            if user!.isParent {
                
                return ChoreType.total.rawValue - 1 // addedChores.count
            }else{
                return user!.chores?.count ?? 0
            }
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasChores == true
        {
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
                cell.choreLabel.text = Chore.choreNames[user!.chores?[indexPath.row].choreType.rawValue ?? 8]
                cell.choreID = user?.chores![indexPath.row].id
                cell.iconImage.image = Chore.getChoreImage(choreType: (user?.chores![indexPath.row].choreType)!)
                cell.iconImage.layer.cornerRadius = 8
                cell.iconImage.layer.masksToBounds = true
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noChoreCell")
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if((user?.isParent)!) == false && hasChores == true{
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
