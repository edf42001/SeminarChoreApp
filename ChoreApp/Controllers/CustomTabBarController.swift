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
//        self.group = Group(id: "sad", name: "My Group", parents: parents, children: [], chores: [])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Use to log out??
    }
 

}
