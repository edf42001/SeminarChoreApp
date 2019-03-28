//
//  YesGroupViewController.swift
//  
//
//  Created by Isaac Hu (student LM) on 3/20/19.
//

import UIKit
import Firebase

class YesGroupTableViewController: UITableViewController {
    var user:User?
    var group:Group?
    
    //Tableview Variables
    enum TableSection: Int {
        case parent = 0, child, total
    }
    let SectionHeaderHeight: CGFloat = 25
    var data = [TableSection: [[String: String]]]()
    var groupData: [[String:String]] = []
    var hasGroup: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = self.tabBarController as! CustomTabBarController
        self.user = tabBar.user
        self.group = tabBar.group
        if let g = self.group {
            hasGroup = true
            groupData = []
            for parent in g.parents {
                groupData.append(["role" : "parent", "username" : parent.username])
            }
            for child in g.children {
                groupData.append(["role" : "child", "username" : child.username])
            }
            
        }else {
            hasGroup = false
        }

        sortData()
        
        if hasGroup {
            tableView.separatorStyle = .singleLine
        }else{
            tableView.separatorStyle = .none
        }
        
        self.tableView.reloadData()
    }
    
    func sortData() {
        data[.parent] = groupData.filter({ $0["role"] == "parent" })
        data[.child] = groupData.filter({ $0["role"] == "child" })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasGroup {
            if let tableSection = TableSection(rawValue: section), let groupData = data[tableSection] {
                return groupData.count
            }
        }else{
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            // Similar to above, first check if there is a valid section of table.
            // Then we check that for the section there is a row.
            if let tableSection = TableSection(rawValue: indexPath.section), let role = data[tableSection]?[indexPath.row] {
                if let titleLabel = cell.viewWithTag(10) as? UILabel {
                    titleLabel.text = role["username"]
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            if let titleLabel = cell.viewWithTag(10) as? UILabel {
                titleLabel.text = "You are not in any groups. Create a new one or wait to be added to one!"
            }
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if hasGroup {
            return TableSection.total.rawValue
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hasGroup {
            return SectionHeaderHeight
        }else{
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if hasGroup{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
            view.backgroundColor = UIColor(red: 178/255.0, green: 34/255.0, blue: 34.0/255.0, alpha: 1)
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor.black
            if let tableSection = TableSection(rawValue: section) {
                switch tableSection {
                case .parent:
                    label.text = "Parents"
                case .child:
                    label.text = "Children"
                default:
                    label.text = ""
                }
            }
            view.addSubview(label)
            return view
        }else{
            return nil
        }
    }

}
