//
//  CustomTabBarController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/14/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var user:User?
    var group:Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if group == nil {
            self.selectedIndex = 1
        }else{
            self.selectedIndex = 0
        }
        
//        self.selectedIndex = 1 //for testing purposes
//        self.user = User(uid: "jkashd", username: "edf42001", email: "how@are.you", isParent: true)
//        let parents = [UserInfo(uid: "1", username: "bob", isParent: true), UserInfo(uid: "2", username: "lui", isParent: true)]
//        self.group = Group(id: "sad", name: "My Group", parents: parents, children: [], chores: [], addedChores: [])
        
        DatabaseHandler.observeIfAddedToGroup(uid: user!.uid, onRecieve: {groupID in
            let groupViewController = ((self.viewControllers?[1] as? UINavigationController)?.viewControllers[0] as? YesGroupTableViewController)
            let choresViewController = ((self.viewControllers?[0] as? UINavigationController)?.viewControllers[0] as? ParentChoresViewContoller)
            let optionsViewController = (self.viewControllers?[2] as? OptionsTableViewController)
            
            groupViewController?.loadViewIfNeeded() //Prevent crash when trying to access view controller before it is loaded
            choresViewController?.loadViewIfNeeded()
            optionsViewController?.loadViewIfNeeded()
            
            if let groupID = groupID as? String {
                DatabaseHandler.readBasicGroupData(groupID: groupID, uid: self.user!.uid, completion: {group, isParent in
                    print("\(groupID), \(isParent)")
                    self.group = group
                    if isParent {
                        print("User is parent")
                        self.user?.isParent = true
                        DatabaseHandler.observeMembersInGroup(groupID: group.id, completion: {parents, children in
                            self.group?.parents = parents
                            self.group?.children = children
                            groupViewController?.loadData()
                            choresViewController?.loadData()
                            optionsViewController?.setupGroupButtonsAndLabel()
                        })
                        DatabaseHandler.observeChores(groupID: groupID, completion: {chores in
                            self.group?.chores = chores
                            groupViewController?.loadData()
                            choresViewController?.loadData()
                            optionsViewController?.setupGroupButtonsAndLabel()
                        })
                    }else {
                        print("User is child")
                        self.user?.isParent = false
                        DatabaseHandler.getChoresForUser(uid: self.user!.uid, groupID: groupID, completion: {chores in
                            self.user?.chores = chores
                        })
                    }
                    groupViewController?.loadData()
                    choresViewController?.loadData()
                    optionsViewController?.setupGroupButtonsAndLabel()
                })
            }else{
                self.group = nil
                groupViewController?.loadData()
                choresViewController?.loadData()
                optionsViewController?.setupGroupButtonsAndLabel()
            }
        })
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Use to log out??
    }
 

}
