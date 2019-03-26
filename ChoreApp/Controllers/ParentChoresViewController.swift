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
    
    @IBOutlet weak var choreTable: UITableView!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        choreTable.dataSource = self
        choreTable.delegate = self
        choreTable.backgroundColor = UIColor.black
        choreTable.rowHeight = UITableViewAutomaticDimension
        choreTable.estimatedRowHeight = 600
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreItem", for: indexPath)
        return cell
    }
    
    
}
