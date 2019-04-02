//
//  AssignChoreViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 4/1/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class AssignChoreViewController: UINavigationController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var group:Group?
    
    @IBOutlet weak var choreName: UILabel!
    @IBOutlet weak var choreIcon: UIImageView!
    @IBOutlet weak var childList: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        childList.dataSource = self
        childList.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let g = self.group {
            return g.children.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let titleLabel = cell.viewWithTag(10) as? UILabel, let g = self.group {
            titleLabel.text = g.children[indexPath.row].username
        }
        return cell
    }

}
