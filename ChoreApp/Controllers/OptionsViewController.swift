//
//  OptionsViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/15/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseAuth

class OptionsViewController: UIViewController {
    
    var user:User?
    var group:Group?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        
        usernameLabel.text = user!.username

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            group = nil
            user = nil
            self.performSegue(withIdentifier: "toStartingScreen", sender: self)
        }catch{let _:NSError
        }
    }
    
    @IBAction func createGroupButtonPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
