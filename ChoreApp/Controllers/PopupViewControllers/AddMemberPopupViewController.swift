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
    var user: User?
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childSwitch.tintColor = UIColorFromRGB(0x373C3C)
        childSwitch.backgroundColor = UIColorFromRGB(0x373C3C)
        childSwitch.layer.cornerRadius = childSwitch.frame.height / 2
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let name = usernameTextField.text {
            //Search the database for the username
            if let groupID = self.group?.id {
                let isParent = !childSwitch.isOn
//                DatabaseHandler.tryAddMemberToGroup(groupID: groupID, newMemberUserName: name, asParent: isParent, completition: {uid, error in
//                    if let uid = uid {
//                        if isParent{
//                             self.group?.parents.append(UserInfo(uid: uid, username: name, isParent: true))
//                        }else{
//                             self.group?.children.append(UserInfo(uid: uid, username: name, isParent: false))
//                        }
//                        self.dismiss(animated: true, completion: nil)
//                    }else{
//                        print(error!)
//                    }
//                })
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        usernameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        return true
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
