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
        addedChores = addedChores + (group?.addedChores)!
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "assignedChore", for: indexPath)
            return cell
        }
        
    }
    
    
}
