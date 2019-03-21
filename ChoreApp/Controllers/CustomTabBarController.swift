//
//  CustomTabBarController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/14/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var user:User?
    var group:Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if group == nil {
            self.selectedIndex = 1
        }else{
            self.selectedIndex = 0
        }
        
        self.selectedIndex = 2 //for testing only
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Use to log out??
    }
 

}
