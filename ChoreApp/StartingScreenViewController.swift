//
//  StartingScreenViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class StartingScreenViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }

}
