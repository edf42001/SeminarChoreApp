//
//  CreateNewGroupViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/6/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class CreateNewGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    var user: User?
    var group: Group?
    var onClose: ((_ created:Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        groupNameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        onClose?(false)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let name = groupNameTextField.text {
            DatabaseHandler.stopObservingIfAddedToGroup()
            DatabaseHandler.createGroup(uid: user!.uid, name: name) {key in
                guard let user = self.user else {return}
                user.groupID = key
                user.isParent = true
                let parent:[UserInfo] = [UserInfo(uid: user.uid, username:user.username, isParent:true)]
                self.group = Group(id: key, name: name, parents: parent, children: [], chores: nil)
                self.dismiss(animated: true, completion: {
                    self.onClose?(true)
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupNameTextField.resignFirstResponder()
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
