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
    
    func numChoresForUser(uid:String) -> Int {
        var numChores = 0
        if let chores = chores {
            for chore in chores {
                if chore.asigneeID == uid {
                    numChores+=1
                }
            }
        }
        return numChores
    }
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

