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
    
    var yGroup:UIViewController?
    var nGroup:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if group == nil {
            self.selectedIndex = 1
        }else{
            self.selectedIndex = 0
        }
        
        let board = UIStoryboard(name: "Group", bundle: nil)
        yGroup = board.instantiateViewController(withIdentifier: "YesGroupViewController")
        nGroup = board.instantiateViewController(withIdentifier: "NoGroupViewController")
        
        //self.selectedIndex = 2 ////for testing only
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
        if item.title == "Group" {
            print(self.viewControllers?.count)
            if var controllers = self.viewControllers {
                controllers[1] = (group == nil ? nGroup! : yGroup!)
            }
            self.viewControllers![1] = (group == nil ? nGroup! : yGroup!)
        }
       
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Use to log out??
    }
 

}
