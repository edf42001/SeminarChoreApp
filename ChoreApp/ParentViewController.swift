//
//  ParentViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/17/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ParentViewController: UIViewController {
    var user:User?
    var group:Group?
    var ref:DatabaseReference!
    
    var enterMemberNameAlert:UIAlertController!
    
    @IBOutlet weak var asParentSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEnterMemberNameAlert()
        ref = Database.database().reference()
//        asParentSwitch.isOn
        
    }
    
    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
        self.present(enterMemberNameAlert, animated: true)
    }
    
    func setupEnterMemberNameAlert() {
        enterMemberNameAlert = UIAlertController(title: "Enter Member Name", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            self.enterMemberNameAlert.dismiss(animated: true)
        })
        
        let createMemberAction = UIAlertAction(title: "Add", style: .default, handler: {action in
            let nameTextField = self.enterMemberNameAlert.textFields![0] as UITextField
            var name:String?
            if let text = nameTextField.text, text != "" {
                name = text
            }
            
            if let name = name, let groupID = self.group?.id {
                self.tryAddMemberToGroup(groupID: groupID, newMemberUserName: name, ref: self.ref, asParent: self.asParentSwitch.isOn, completition: {error in
                    if error {
                        print("No user with that username")
                    }else{
                        self.enterMemberNameAlert.dismiss(animated: true)
                    }
                })
            }
        })
        
        enterMemberNameAlert.addAction(cancelAction)
        enterMemberNameAlert.addAction(createMemberAction)
        enterMemberNameAlert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter Username"
        })
    }
    
    func tryAddMemberToGroup(groupID:String, newMemberUserName:String, ref:DatabaseReference, asParent:Bool, completition:@escaping (_ error:Bool)->()){
        let handle = ref.child("usernames/\(newMemberUserName)").observe(.value, with: { snapshot in
            if let uid = snapshot.value as? String {
                ref.child("groups/\(groupID)/members/\(uid)").setValue(asParent)
                ref.child("users/\(uid)/group").setValue(groupID)
                completition(false)
            }else{
                completition(true)
            }
        })
        ref.removeObserver(withHandle: handle)
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
