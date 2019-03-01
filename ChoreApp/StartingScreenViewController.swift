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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Styles.backgroundColor
        loginButton.applyButtonStyles(type: .standard)
        signUpButton.applyButtonStyles(type: .standard)
    }
}
