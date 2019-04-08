//
//  OptionsTableViewController.swift
//  FirebaseAuth
//
//  Created by Ethan Frank (student LM) on 3/20/19.
//

import UIKit
import FirebaseAuth

class OptionsTableViewController: UITableViewController {
    var user:User?
    var group:Group?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var leaveGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        
        usernameLabel.text = user!.username
        emailLabel.text = user!.email
        
        setupGroupButtonsAndLabel()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {action in
            do{
                try Auth.auth().signOut()
                DatabaseHandler.stopObservingChores()
                DatabaseHandler.stopObservingMembersInGroup()
                self.group = nil
                self.user = nil
                self.performSegue(withIdentifier: "toStartingScreen", sender: self)
            }catch{let _:NSError
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createGroupButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Leave Group", message: "Are you sure you want to leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: {action in
            DatabaseHandler.stopObservingChores()
            DatabaseHandler.stopObservingMembersInGroup()
            DatabaseHandler.leaveGroup(uid: self.user!.uid, groupID: self.group!.id, isParent: self.user!.isParent, done: {
                self.user?.groupID = nil
                self.group = nil
                self.setupGroupButtonsAndLabel()
                let tabBar = self.tabBarController as! CustomTabBarController
                tabBar.user?.groupID = nil
                tabBar.group = nil
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupGroupButtonsAndLabel() {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        
        createGroupButton.isEnabled = (group == nil)
        leaveGroupButton.isEnabled = (group != nil)
        if group == nil {
            groupNameLabel.text = "N/A"
        }else{
            groupNameLabel.text = group!.name
        }
       
    }
    
    //    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = UIColor.white
//    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateGroupPopup"{
            guard let destination = segue.destination as? CreateNewGroupViewController else {return}
            destination.user = self.user
            destination.group = self.group
            destination.onClose = {name in
                if let name = name {
                    DatabaseHandler.stopObservingIfAddedToGroup()
                    DatabaseHandler.createGroup(uid: self.user!.uid, name: name) {key in
                        self.user!.groupID = key
                        self.user!.isParent = true
                        let parent:[UserInfo] = [UserInfo(uid: self.user!.uid, username:self.user!.username, isParent:true)]
                        self.group = Group(id: key, name: name, parents: parent, children: [], chores: nil, addedChores: nil)
                        let tabBar = self.tabBarController as! CustomTabBarController
                        tabBar.group = self.group
                    }
                    self.setupGroupButtonsAndLabel()
                }
            }
        }else{
            print("Failed segue error")
        }
    }
}
