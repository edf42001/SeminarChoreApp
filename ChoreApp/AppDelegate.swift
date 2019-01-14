//
//  AppDelegate.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 11/27/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var user: User?
    
    var toScreen = -1
    
    var ref: DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        ref = Database.database().reference()
        if let user = Auth.auth().currentUser  {
            self.user = User(uid: user.uid, username: user.displayName ?? "", email: user.email ?? "", isParent: false)
            ref.child("users/\(user.uid)/group").observeSingleEvent(of: .value, with: {snapshot in
                if let groupID = snapshot.value as? String {
                    self.user?.groupID = groupID
                }
                else {
                    let storyboard = UIStoryboard(name: "MainApp", bundle: nil)
                    let noGroup = storyboard.instantiateViewController(withIdentifier: "NoGroupViewController") as! NoGroupViewController
                    self.window?.rootViewController = noGroup
                    noGroup.user = self.user
                }
            })
            ref.child("groups/\(self.user?.groupID)/members/\(self.user?.uid)").observeSingleEvent(of: .value, with: {snapshot in
                if let parentalStatus = snapshot.value as? String {
                    if parentalStatus == "child" {
                        let storyboard = UIStoryboard(name: "MainApp", bundle: nil)
                        let child = storyboard.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
                        self.window?.rootViewController = child
                        child.user = self.user
                    }
                    else if parentalStatus == "parent" {
                        let storyboard = UIStoryboard(name: "MainApp", bundle: nil)
                        let parent = storyboard.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
                        self.window?.rootViewController = parent
                        parent.user = self.user
                    }
                }
            })
        }
        else {
            let storyboard = UIStoryboard(name: "Accounts", bundle: nil)
            let start = storyboard.instantiateViewController(withIdentifier: "StartingScreenViewController") as! StartingScreenViewController
            self.window?.rootViewController = start
        }
        window?.makeKeyAndVisible()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
