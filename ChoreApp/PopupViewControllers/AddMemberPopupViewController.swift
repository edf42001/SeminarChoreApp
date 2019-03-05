//
//  AddMemberPopupViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/5/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class AddMemberPopupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var childSwitch: UISwitch!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
