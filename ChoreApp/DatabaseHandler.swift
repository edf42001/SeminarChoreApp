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
    
    static func observeIfAddedToGroup(uid:String, onRecieve: @escaping (Any?)->()) -> (){
        let key = ref.child("users/\(uid)/group").observe(.value, with: {snapshot in
            onRecieve(snapshot.value)
        })
        observers["ifAddedToGroup"] = key
    }
    
    static func stopObservingIfAddedToGroup(){
        if let key = observers["ifAddedToGroup"] {
            ref.removeObserver(withHandle: key)
            observers.removeValue(forKey: "ifAddedToGroup")
        }
    }
    
    static func leaveGroup(uid:String, groupID:String, isParent:Bool, done: @escaping()->()){
        ref.child("groups/\(groupID)/members").observeSingleEvent(of: .value, with: {snapshot in
            let dispatchGroup = DispatchGroup()
            var parentCount = 0
            
            if let members = snapshot.value as? [String:String], isParent{ //don't count if not parent
                for parentStatus in members.values {
                    if parentStatus == "parent"{
                        parentCount+=1
                    }
                }
                dispatchGroup.enter()
                ref.child("users/\(uid)/group").removeValue() {error, ref in
                    dispatchGroup.leave()
                }
                
                if parentCount > 1 {
                    dispatchGroup.enter()
                    ref.child("groups/\(groupID)/members/\(uid)").removeValue() {error, ref in
                        dispatchGroup.leave()
                    }
                }else{

                    dispatchGroup.enter()
                    ref.child("groups/\(groupID)").removeValue() {error, ref in
                        dispatchGroup.leave()
                    }
                    for uid in members.keys {
                        dispatchGroup.enter()
                        ref.child("users/\(uid)/group").removeValue() {error, ref in
                            dispatchGroup.leave()
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    done()
                }
            }
        })
    }
    
    static func addChore(name:String, asigneeUid: String, groupID:String, completion: @escaping (_ id:String)->()){
        let key = ref.child("groups/\(groupID)/chores/\(asigneeUid)").childByAutoId().key ?? ""
        ref.child("groups/\(groupID)/chores/\(asigneeUid)/\(key)/name").setValue(name)
        completion(key)
    }
    
    static func removeChore(asigneeUid:String, choreID:String, groupID:String, uid:String){
        ref.child("groups/\(groupID)/chores/\(asigneeUid)/\(choreID)").removeValue()
    }
    
    static func observeMembersInGroup(groupID: String, completion: @escaping(_ parents:[UserInfo], _ children:[UserInfo])->()){
        let key = ref.child("groups/\(groupID)/members").observe(.value, with: {snapshot in
            var parents:[UserInfo] = []
            var children:[UserInfo] = []
            if let members = snapshot.value as? [String:String] {
                let dispatchGroup = DispatchGroup()
                for (uid, parentStatus) in members {
                    dispatchGroup.enter()
                    getMemberUsername(uid: uid, completion: {username in
                        if let username = username {
                            if parentStatus == "parent" {
                                parents.append(UserInfo(uid: uid, username: username, isParent: true))
                            }else{
                                children.append(UserInfo(uid: uid, username: username, isParent: false))
                            }
                        }
                        dispatchGroup.leave()
                    })
                }
                dispatchGroup.notify(queue: .main, execute: {
                    completion(parents, children)
                })
            }
        })
        observers["membersInGroup"] = key
    }
    
    static func stopObservingMembersInGroup() {
        if let key = observers["membersInGroup"] {
            ref.removeObserver(withHandle: key)
            observers.removeValue(forKey: "membersInGroup")
        }
    }
    
    static func readBasicGroupData(groupID: String, uid:String, completion: @escaping((_ group:Group, _ isParent:Bool)->())){
        let group = Group(id: groupID, name: "", parents: [], children: [], chores: nil)
        ref.child("groups/\(groupID)").observeSingleEvent(of: .value, with: {snapshot in
            if let groupData = snapshot.value as? [String:Any] {
                if let name = groupData["name"] as? String{
                    group.name = name
                }
                if let members = groupData["members"] as? [String:String] {
                    print("member uid: \(members[uid])")
                    let userIsParent = members[uid] == "parent"
                    let dispatchGroup = DispatchGroup()
                    for (uid, parentStatus) in members {
                        dispatchGroup.enter()
                        getMemberUsername(uid: uid, completion: {username in
                            if let username = username {
                                if parentStatus == "parent" {
                                    group.parents?.append(UserInfo(uid: uid, username: username, isParent: true))
                                }else{
                                    group.children?.append(UserInfo(uid: uid, username: username, isParent: false))
                                }
                            }
                            dispatchGroup.leave()
                        })
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        completion(group, userIsParent)
                    })
                }
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
    
    static func getAllChoresFromGroup(groupID:String, completion: @escaping(_ chores:[Chore])->()){
        //If the user is a parent then they will get all the chores
        ref.child("groups/\(groupID)/chores").observeSingleEvent(of: .value, with: {snapshot in
            var chores:[Chore] = []
            if let data = snapshot.value as? [String:Any] {
                for (asigneeID, choreList) in data {
                    chores.append(contentsOf: parseChoreList(choreList: choreList, uid:asigneeID))
                }
            }
            completion(chores)
        })
    }
    
    static func observeChores(groupID:String, completion: @escaping(_ chores:[Chore])->()){
        let key = ref.child("groups/\(groupID)/chores").observe(.value, with: {snapshot in
            var chores:[Chore] = []
            if let data = snapshot.value as? [String:Any] {
                for (asigneeID, choreList) in data {
                    chores.append(contentsOf: parseChoreList(choreList: choreList, uid:asigneeID))
                }
            }
            completion(chores)
        })
        observers["choresInGroup"] = key
    }
    
    static func stopObservingChores() {
        if let key = observers["choresInGroup"] {
            ref.removeObserver(withHandle: key)
            observers.removeValue(forKey: "choresInGroup")
        }
    }
    
    static func getChoresForUser(uid:String, groupID:String, completion: @escaping(_ chores:[Chore])->()){
        //, but if they are a child they will onyl get their chores
        ref.child("groups/\(groupID)/chores/\(uid)").observeSingleEvent(of: .value, with: {snapshot in
            let chores:[Chore] = parseChoreList(choreList: snapshot.value, uid: uid)
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
    
    private static func parseChoreList(choreList:Any?, uid:String)->[Chore]{
        var chores:[Chore] = []
        if let choreList = choreList as? [String:[String:String]] {
            for (choreID, choreData) in choreList {
                if let name = choreData["name"] {
                    let chore = Chore(id: choreID, name: name, asigneeID: uid)
                    chores.append(chore)
                }
            }
        }
        return chores
    }
    
}
