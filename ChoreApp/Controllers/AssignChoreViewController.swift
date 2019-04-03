//
//  AssignChoreViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 4/1/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class AssignChoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var group:Group?
    var chore:Chore?
    
    @IBOutlet weak var choreName: UILabel!
    @IBOutlet weak var choreIcon: UIImageView!
    @IBOutlet weak var childList: UITableView!
    @IBOutlet weak var createButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.applyButtonStyles(type: .standard)
        choreName.text = Chore.choreNames[chore!.choreType.rawValue]
        choreIcon.image = Chore.getChoreImage(choreType: self.chore!.choreType)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group!.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let titleLabel = cell.viewWithTag(10) as? UILabel, let g = self.group {
            titleLabel.text = g.children[indexPath.row].username
        }
        return cell
    }
    
    @IBAction func createChore(_ sender: Any) {
        var count = 0
        for cell in childList.visibleCells {
            if let check = cell.viewWithTag(20) as? UISwitch {
                if check.isOn {
                    count += 1
                    let child = self.group?.children[childList.visibleCells.firstIndex(of: cell)!]
                    DatabaseHandler.addChore(name: chore!.name, type: self.chore!.choreType, asigneeUid: child!.uid, groupID: self.group!.id, completion: {id in
                        //add the chore to the group
                        if let ch = self.chore {
                            self.group?.chores?.append(ch)
                        }
                    })
                }
            }
        }
        if count > 0 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
