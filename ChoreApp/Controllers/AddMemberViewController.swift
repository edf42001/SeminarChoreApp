//
//  AddMemberViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/22/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class AddMemberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var parentChildSwitch: UISegmentedControl!
    @IBOutlet weak var addMemberButton: UIButton!
    
    var group:Group?
    var user:User?
    
    var hasValidMember:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        
        errorMessageLabel.text = ""
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = textField.text {
            DatabaseHandler.checkIfCanAddMemberToGroup(groupID: group!.id, newMemberUserName: name, completition: {error in
                let fadeTransition = CATransition()
                fadeTransition.duration = 0.05
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    if error == "User already in group" {
                        self.errorMessageLabel.text = "User already in group"
                    }else if error == "User does not exist" {
                        self.errorMessageLabel.text = "No user with that name found"
                    }else{
                        self.errorMessageLabel.text = ""
                    }
                     self.errorMessageLabel.layer.add(fadeTransition, forKey: kCATransition)
                })
                
                self.errorMessageLabel.text = ""
                self.errorMessageLabel.layer.add(fadeTransition, forKey: kCATransition)
                
                CATransaction.commit()
                
                self.hasValidMember = (error == nil)
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func controlClicked(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        if sender.selectedSegmentIndex == 0 {
             addMemberButton.setTitle("Add Parent", for: .normal)
        }else{
            addMemberButton.setTitle("Add Child", for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let name = usernameTextField.text, hasValidMember {
            let asParent = parentChildSwitch.selectedSegmentIndex == 0
             DatabaseHandler.addMemberToGroup(groupID: group!.id, newMemberUserName: name, asParent: asParent, completition: {error in
                self.dismiss(animated: true, completion: nil)
             })
        }
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
