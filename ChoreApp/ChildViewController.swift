//
//  ChildViewController.swift
//  ChoreApp
//
//  Created by Isaac Hu (student LM) on 1/17/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    var user:User?
    var group:Group?
    var ref:DatabaseReference!
    
    @IBOutlet weak var choreTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.chores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreCell", for: indexPath) as! ChoreTableViewCell
        
        if let groupChores = group?.chores
        {
            for i in groupChores
            {
                if let userChore = user?.chores?[indexPath.row]
                {
                    if i.id == userChore.id
                    {
                       
                        
                        cell.choreLabel.text = i.name
                        cell.choreID = i.id
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let confirmationMessage = UIAlertController(title: "Please Confirm", message: choreTable.cellForRow(at: indexPath)?.textLabel?.text, preferredStyle: .alert)
        confirmationMessage.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        confirmationMessage.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            let cell = tableView.cellForRow(at: indexPath) as! ChoreTableViewCell
            if var userChores = self.user?.chores
            {
                var index : Int? = nil
                for userChore in userChores
                {
                    if userChore.id == cell.choreID
                    {
                        index = userChores.index(where: { (chore) -> Bool in
                            chore.id == cell.choreID
                        })
                    }
                }
                if let unwrappedIndex = index
                {
                    userChores.remove(at: unwrappedIndex)
                }
            }
            if var groupChores = self.group?.chores
            {
                var index : Int? = nil
                for groupChore in groupChores
                {
                    if groupChore.id == cell.choreID
                    {
                        index = groupChores.index(where: { (chore) -> Bool in
                            chore.id == cell.choreID
                        })
                    }
                }
                if let unwrappedIndex = index
                {
                    groupChores.remove(at: unwrappedIndex)
                }
            }
            
            self.ref.child("groups/\(self.group!.id)/chores/\(cell.choreID)").setValue(nil)
            self.ref.child("users/\(self.user!.uid)/chores/\(cell.choreID)").setValue(nil)
            tableView.reloadData()

        }))
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: Any) {
        guard let uid = user?.uid, let groupID = group?.id else {return}
        DatabaseHandler.leaveGroup(uid: uid, groupID: groupID)
        user?.groupID = nil
        group = nil
        self.performSegue(withIdentifier: "toNoGroupController", sender: self)
    }
    
    
    
}
