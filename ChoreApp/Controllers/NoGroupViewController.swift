//
//  NoGroupViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/17/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit
import Firebase

class NoGroupViewController: UIViewController {
    
    //General variables
    var user:User?
    var group:Group?
    var toScreen = -1
    var menuOpen = false
    @IBOutlet weak var noGroup: UIView!
    
    //Tableview Variables
    enum TableSection: Int {
        case parent = 0, child, total
    }
    let SectionHeaderHeight: CGFloat = 25
    var data = [TableSection: [[String: String]]]()
    var groupData: [[String:String]] = []
    
    override func viewDidLoad() {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        toScreen = -1
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        noGroup.backgroundColor = UIColor.black
        DatabaseHandler.observeIfAddedToGroup(uid: user!.uid, onRecieve: {groupID in
            if let groupID = groupID as? String, self.toScreen == -1{
                DatabaseHandler.readBasicGroupData(groupID: groupID, uid: self.user!.uid, completion: {group, isParent in
                    print("\(groupID), \(isParent)")
                    self.group = group
                    if isParent {
                        print("User is parent")
                        self.user?.isParent = true
                        self.toScreen = 1
                        DatabaseHandler.getAllChoresFromGroup(groupID: groupID, completion: {chores in
                            self.group?.chores = chores
                        })
                        
                    }else {
                        print("User is child")
                        self.user?.isParent = false
                        self.toScreen = 2
                        DatabaseHandler.getChoresForUser(uid: self.user!.uid, groupID: groupID, completion: {chores in
                            self.user?.chores = chores
                        })
                    }
                    DatabaseHandler.stopObservingIfAddedToGroup()
                })
            }
        })
    }

    // MARK: - Navigation

    //Transfer the user's information to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch toScreen {
        case 1:
            guard let destination = segue.destination as? ParentViewController else {return}
            destination.user = self.user
            destination.group = self.group
        case 2:
            guard let destination = segue.destination as? ChildViewController else {return}
            destination.user = self.user
            destination.group = self.group
        default:
            break
        }
    }
    

}
