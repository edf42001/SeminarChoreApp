//
//  DatabaseHandler.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 2/1/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseHandler {
    static var ref = Database.database().reference()
    static var observers:[String:UInt] = [:]
    
    static func readData(dataPath:String, onRecieve: @escaping (Any?)->()) {
        ref.child(dataPath).observeSingleEvent (of: .value, with: {snapshot in
            onRecieve(snapshot.value)
        })
    }
    
    static func addObserver(name:String, dataPath:String, onRecieve: @escaping (Any?)->()) {
        let handle = ref.child(dataPath).observe(.value, with: {snapshot in
            onRecieve(snapshot.value)
        })
        
        observers[name] = handle
    }
    
    static func removeObserver(name:String) {
        if let handle = observers[name] {
            ref.removeObserver(withHandle: handle)
            observers.removeValue(forKey: name)
        }else{
            print("no observer with that name")
        }
    }
    
    static func addUser(username:String, uid:String, email:String){
        ref.child("users/\(uid)").setValue(["username":username,
                                            "email":email])
        ref.child("usernames/\(username)").setValue(uid)
    }
    
    static func createGroup(uid:String, name:String, completion: @escaping (_ key:String)->()){
        let key = ref.child("groups").childByAutoId().key ?? ""
        ref.child("groups/\(key)").setValue(["name":name,
                                             "members":[uid:"parent"]])
        ref.child("users/\(uid)/group").setValue(key)
        completion(key)
    }
    
    static func tryAddMemberToGroup(groupID:String, newMemberUserName:String, asParent:Bool, completition:@escaping (_ uid:String?)->()){
        ref.child("usernames/\(newMemberUserName)").observeSingleEvent(of: .value, with: { snapshot in
            if let uid = snapshot.value as? String {
                ref.child("groups/\(groupID)/members/\(uid)").setValue(asParent ? "parent":"child")
                ref.child("users/\(uid)/group").setValue(groupID)
                completition(uid)
            }else{
                completition(nil)
            }
        })
    }
    
    static func observeIfAddedToGroup(uid:String) -> UInt{
        return ref.child("users/\(uid)/group").observe(.value, with: {snapshot in
            if snapshot.exists(){
                print("I, \(uid), was added to a group!")
            }
        })
    }
    
    static func observeNewChores(uid:String, groupID:String) -> UInt{
        return ref.child("users/\(uid)/chores/").observe(.value, with: {snapshot in
            if snapshot.exists(){
                print(snapshot)
            }
        })
    }
    
    static func leaveGroup(uid:String, groupID:String){
        ref.child("users/\(uid)/group").removeValue()
        ref.child("groups/\(groupID)/members/\(uid)").removeValue()
    }
    
    static func addChore(name:String, asigneeUid: String, groupID:String){
        let key = ref.child("groups/\(groupID)/chores/\(asigneeUid)").childByAutoId().key ?? ""
        ref.child("groups/\(groupID)/chores/\(key)").setValue(["name":name,
                                                               "asignee":asigneeUid])
    }
    
    static func removeChore(asigneeUid:String, choreID:String, groupID:String, uid:String){
        ref.child("groups/\(groupID)/chores/\(asigneeUid)/\(choreID)").removeValue()
    }
    
    static func readBasicGroupData(groupID: String, uid:String, completition: @escaping((_ group:Group, _ isParent:Bool)->())){
        let group = Group(id: groupID, name: "", parents: [], children: [], chores: nil)
        getMembersInGroup(groupID: groupID, completion: {memberData in
            if let memberData = memberData {
                let userIsParent = memberData[uid] == "parent"
                
                let dispatchGroup = DispatchGroup()
                for uid in memberData.keys{
                    dispatchGroup.enter()
                    getMemberUsername(uid: uid, completion: {username in
                        if let username = username {
                            if memberData[uid] == "parent" {
                                group.parents?.append(UserInfo(uid: uid, username: username, isParent: true))
                            }else{
                                group.children?.append(UserInfo(uid: uid, username: username, isParent: false))
                            }
                        }
                        dispatchGroup.leave()
                    })
                }
                dispatchGroup.notify(queue: .main, execute: {
                    completition(group, userIsParent)
                })
            }
        })
    }
    
    private static func getMembersInGroup(groupID:String, completion:@escaping(_ members:[String:String]?)->()){
        ref.child("groups/\(groupID)/members").observeSingleEvent(of: .value, with: {snapshot in
            if let membersData = snapshot.value as? [String:String] {
                completion(membersData)
            }else{
                completion(nil)
                print("Couldn't get members in group")
            }
        })
    }
    
    private static func getMemberUsername(uid:String, completion: @escaping (String?)->()){
        ref.child("/users/\(uid)/username").observeSingleEvent(of: .value, with: {snapshot in
            if let usernameData = snapshot.value as? String{
                completion(usernameData)
            }else{
                completion(nil)
                print("Couldn't get member username")
            }
        })
    }
    
    static func getAllGroupChores(groupID:String, completion: @escaping(_ chores:[Chore])->()){
        ref.child("groups/\(groupID)/chores").observeSingleEvent(of: .value, with: {snapshot in
            var chores:[Chore] = []
            if let data = snapshot.value as? [String:[String:String]] {
                for key in data.keys {
                    if let name = data[key]?["name"], let asigneeID = data[key]?["asigneeID"]{
                        let chore = Chore(id: key, name: name, asigneeID: asigneeID)
                        chores.append(chore)
                    }
                }
            }
            print(chores)
            completion(chores)
        })
    }
    
    static func getChoresForUser(uid:String, groupID:String, completion: @escaping(_ chores:[Chore])->()){
        ref.child("users/\(uid)/chores").observeSingleEvent(of: .value, with: {snapshot in
            var chores:[Chore] = []
            if let data = snapshot.value as? [String] {
                print(data)
            }
            print(chores)
            completion(chores)
        })
    }
    
    static func readUserData(uid:String, completion: @escaping (_ groupID:String?, _ isParent:Bool)->()){
        ref.child("users/\(uid)/group").observeSingleEvent(of: .value, with: {snapshot in
            if let groupID = snapshot.value as? String {
                ref.child("groups/\(groupID)/members/\(uid)").observeSingleEvent(of: .value, with: {snapshot in
                    if let parentalStatus = snapshot.value as? String {
                        if parentalStatus == "child" {
                            
                            
                            completion(groupID, false)
                        }else if parentalStatus == "parent" {
                            completion(groupID, true)
                        }else{
                            print("They were not a parent or a child halp")
                        }
                    }
                })
            }else{
                completion(nil, false)
            }
        })
    }
}
