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
    var parents:[UserInfo]
    var children:[UserInfo]
    var chores:[Chore]?
    var addedChores:[CustomChore]?
    init(id:String, name:String, parents:[UserInfo], children:[UserInfo], chores:[Chore]?, addedChores:[CustomChore]?){
        self.id = id
        self.name = name
        self.parents = parents
        self.children = children
        self.chores = chores
        self.addedChores = addedChores
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

struct UserInfo{
    let uid:String
    let username:String
    let isParent:Bool
    
    init(uid:String, username:String, isParent:Bool){
        self.uid = uid
        self.username = username
        self.isParent = isParent
    }
}

