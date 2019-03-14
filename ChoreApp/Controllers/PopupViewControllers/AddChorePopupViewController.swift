//
//  AddChorePopupViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 3/7/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit

class AddChorePopupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var choreNameTextField: UITextField!
    @IBOutlet weak var asigneeTextField: UITextField!
    
    var group:Group?
    var list:[String] = []
    var asigneeRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list.append("---")
        for user in group!.children{
            list.append(user.username)
        }
        pickerView.isHidden = true
        choreNameTextField.becomeFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        asigneeTextField.text = list[row]
        pickerView.isHidden = true
        asigneeRow = row
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == asigneeTextField {
            pickerView.isHidden = false
            textField.endEditing(true)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        choreNameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let choreName = choreNameTextField.text, asigneeRow > 0, choreName != "" {
            let asigneeUid = self.group!.children[asigneeRow-1].uid
            DatabaseHandler.addChore(name: choreName, asigneeUid: asigneeUid, groupID: group!.id, completion: {id in
                self.group?.chores?.append(Chore(id: id, name: choreName, asigneeID: asigneeUid))
            })
            choreNameTextField.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
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
