//
//  UserController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    // MARK: - Properties
    var currentUser: User?
    
    var db: Firestore!
    
    var userUID: String {
        // TODO - better way to do this?
        get {
            guard let userUID = Auth.auth().currentUser?.uid else {
                //fatalError("Error unwrappig currentUser uid")
                return ""
            }
            return userUID
        }
    }
    
    // Source of truth
    static let shared = UserController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    // MARK: - Load User from Firestore
    func loadUser(completion: @escaping () -> ()) {
        db.collection(DatabaseReference.userDatabase).document(userUID).addSnapshotListener { (document, error) in
            if let error = error {
                print("Error loading data: \(error.localizedDescription)")
                return completion()
            }
            
            guard let documentData = document?.data() else { completion() ; return }
            let user = User(dictionary: documentData)
            self.currentUser = user
            completion()
        }
//
//
//
//        db.collection(DatabaseReference.userDatabase).document(userUID).addSnapshotListener({ (document, error) in
//            if let error = error {
//                print("Error loading data: \(error.localizedDescription)")
//                return completion()
//            }
//
//        })
//            .addSnapshotListener { (document, error) in
//
//
//                // Found document
//                let user = User(dictionary: document)
//                completion()
//        }
//
//        let docRef = db.collection(DatabaseReference.userDatabase).document(uid)
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                //guard let username = document["username"] as? String else { return }
//                //self.welcomeLabel.text = "Welcome, \(username)"
//
//                //                UIView.animate(withDuration: 0.5, animations: {
//                //                    self.welcomeLabel.alpha = 1
//                //                })
//
//                UserController.shared.loadUser() {
//
//                }
//                // Present Main Tabbar
//                //                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
//                //                guard let controller = navController.viewControllers[0] as? HomeController else { return }
//                //
//                //                let tabbarViewController = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "Tabbar")
//                //
//                //                guard let tabController = UIApplication.shared.keyWindow?.resignKey() as UITabBarController else { return }
//                //                guard let controller = tabBarController?.viewControllers[0] as
//                //
//                //                if let tabBar = self.tabBarController {
//                //
//                //                    self.present(tabBar, animated: true, completion: nil)
//                //                }
//                let tabbarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
//                self.present(tabbarViewController, animated: true, completion: nil)
//
//            } else {
//                print("Document does not exist")
//            }
//        }
    }
}
