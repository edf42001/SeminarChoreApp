//
//  ViewController.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 11/27/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
//      addUser(username: "bobisthebest", uid: "1klasjd-sadnx", email: "bob@bob.com", ref: ref)
//      createGroup(uid: "askdjh-34ehjk", name: "My Group", ref: ref)
//        observeIfAddedToGroup(uid: "1klasjd-sadnx", ref: ref)
//        addMemberToGroup(groupID:"-LThDJhiQqk7tsTLXhXV", newMemberUserName: "bobisthebest", ref: ref, asParent: false)
//        leaveGroup(uid: "1klasjd-sadnx", groupID:"-LThDJhiQqk7tsTLXhXV", ref: ref)
//          addChore(name: "Take out recycling", asigneeUid: "askdjh-34ehjk", groupID: "-LThDJhiQqk7tsTLXhXV", ref: ref)
//        addChore(name: "Do the laundry", asigneeUid: "askdjh-34ehjk", groupID: "-LThDJhiQqk7tsTLXhXV", ref: ref)
//        removeChore(choreID: "-LTijDNkGs1HGvj41U8q", groupID: "-LThDJhiQqk7tsTLXhXV", uid: "askdjh-34ehjk", ref: ref)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addUser(username:String, uid:String, email:String, ref:DatabaseReference){
        ref.child("users/\(uid)").setValue(["username":username,
                                            "email":email])
        ref.child("usernames/\(username)").setValue(uid)
    }
    
    func createGroup(uid:String, name:String, ref:DatabaseReference){
        let key = ref.child("groups").childByAutoId().key ?? ""
        ref.child("groups/\(key)").setValue(["name":name,
                                             "members":[uid:true]])
        ref.child("users/\(uid)/group").setValue(key)
        
    }
    
    func addMemberToGroup(groupID:String, newMemberUserName:String, ref:DatabaseReference, asParent:Bool){
        let handle = ref.child("usernames/\(newMemberUserName)").observe(.value, with: { snapshot in
            if let uid = snapshot.value as? String {
                ref.child("groups/\(groupID)/members/\(uid)").setValue(asParent)
                ref.child("users/\(uid)/group").setValue(groupID)
            }else{
                print("No user with that name found")
            }
        })
        ref.removeObserver(withHandle: handle)
    }
    
    func observeIfAddedToGroup(uid:String, ref:DatabaseReference) -> UInt{
        return ref.child("users/\(uid)/group").observe(.value, with: {snapshot in
            if snapshot.exists(){
                print("I, \(uid), was added to a group!")
            }
        })
    }
    
    func observeNewChores(uid:String, groupID:String, ref:DatabaseReference) -> UInt{
        return ref.child("users/\(uid)/chores/").observe(.value, with: {snapshot in
            if snapshot.exists(){
                print(snapshot)
            }
        })
    }
    
    func leaveGroup(uid:String, groupID:String, ref:DatabaseReference){
        ref.child("users/\(uid)/group").removeValue()
        ref.child("groups/\(groupID)/members/\(uid)").removeValue()
    }
    
    func addChore(name:String, asigneeUid: String, groupID:String, ref:DatabaseReference){
        let key = ref.child("groups/\(groupID)/chores").childByAutoId().key ?? ""
        ref.child("groups/\(groupID)/chores/\(key)").setValue(["name":name,
                                                               "asignee":asigneeUid])
        ref.child("users/\(asigneeUid)/chores/\(key)").setValue(true)
    }
    
    func removeChore(choreID:String, groupID:String, uid:String, ref:DatabaseReference){
         ref.child("groups/\(groupID)/chores/\(choreID)").removeValue()
         ref.child("users/\(uid)/chores/\(choreID)").removeValue()
    }
}

