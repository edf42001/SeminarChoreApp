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
    let ref:DatabaseReference!
    let username:String
    var uid:String?
    var email:String?
    var displayName:String?
    var group:Group?

    init(username:String){
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
        self.username = username
        self.ref = Database.database().reference()
    }
    
    func updateUserData(){
        self.ref.child("usernames/\(self.username)").setValue(self.uid)
        
    }

    func joinGroup(group:Group){
        self.ref.child("users/\(self.uid)/group/\(group.id)").setValue(true)
    }

}
