//
//  Group.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/11/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import Foundation
import Firebase

class Group{
    var members:[User]?
    var chores:[Chore]?
    var name:String?
    var id:String
    let ref:DatabaseReference!
    
    init(name:String, creator:User){
        self.ref = Database.database().reference()
        self.id = ref.child("groups").childByAutoId().key ?? ""
        self.ref.child("groups/\(id)").setValue(["name":name,
                                                 "members":[creator.uid:"parent"]
                                                 ])
        
    }

    func addMember(userName:String) {
        self.ref.child("usernames/\(userName)").observeSingleEvent(of: .value) {snapshot in
            let uid = snapshot as? String ?? ""
            
        }
        self.ref.child("groups/\(id)")
        
    }
    
    func addChore(chore:Chore){
        
    }
}

