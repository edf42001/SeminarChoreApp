//
//  User.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/11/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import Foundation
import Firebase

class User {
    let uid:String
    let username:String
    let email:String
    var groupID: String?
    var chores:[Chore]?
    
    init(uid:String, username: String, email:String){
        self.uid = uid
        self.username = username
        self.email = email
    }
    
}
