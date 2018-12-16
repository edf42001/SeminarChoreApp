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
    let id:String
    var name:String
    var members:[String:String] //username:uid
    var chores:[Chore]?
    
    init(id:String, name:String){
        self.id = id
        self.name = name
//        self.members = getMembers()
//        self.chores = getChores()
    }
    
//    init(name:String, creator:User){
//        self.ref = Database.database().reference()
//        self.id = ref.child("groups").childByAutoId().key ?? ""
//        self.ref.child("groups/\(id)").setValue(["name":name,
//                                                 "members":[creator.uid:"parent"]
//                                                 ])
//
//    }
//
//    func addMember(userName:String) {
//        self.ref.child("usernames/\(userName)").observeSingleEvent(of: .value) {snapshot in
//            let uid = snapshot as? String ?? ""
//
//        }
//        self.ref.child("groups/\(id)")
//
//    }
}

