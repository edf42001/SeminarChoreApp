//
//  GroupNavigationController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 3/20/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class GroupNavigationController: UINavigationController {

    var group:Group?
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        
        let groupStoryboard: UIStoryboard = UIStoryboard(name: "Group", bundle: nil)
        let NoViewController = groupStoryboard.instantiateViewController(withIdentifier: "NoGroupViewController") as! NoGroupViewController
        let YesViewController = groupStoryboard.instantiateViewController(withIdentifier: "YesGroupViewController") as! YesGroupViewController
        
        self.viewControllers.removeAll()
        if let _ = group {
            self.pushViewController(YesViewController, animated: false)
        }
        else {
            
        }
        self.pushViewController(NoViewController, animated: false)
        self.popToRootViewController(animated: false)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
