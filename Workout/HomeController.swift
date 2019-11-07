//
//  HomeController.swift
//  Workout
//
//  Created by Chris Grayston on 4/3/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    var db: Firestore!
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        authenticateUserAndConfigureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fullScreen()
    }
    
    // MARK: - Selectors
    
//    @objc func handleSignOut() {
//        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
//            self.signOut()
//        }))
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alertController, animated: true, completion: nil)
//    }
    
    // MARK: - API
    
    func loadUserData() {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Get programs user follows
//        DispatchQueue.main.async {
//            ProgramController.shared.getUserFollowedAndCreatedPrograms { (followedPrograms, createdPrograms) in
//                self.followedPrograms = followedPrograms
//                self.createdPrograms = createdPrograms
//                self.tableView.reloadData()
//            }
//        }
        let dispatchGroup = DispatchGroup()
        ProgramController.shared.setUserFollowedAndCreatedPrograms { (success) in
            dispatchGroup.enter()
            //dispatchGroup.leave()
            if success {
                NotificationCenter.default.post(name: NotificationCenterNames.programUpdated, object: nil)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        UserController.shared.loadUser {
            
            //dispatchGroup.leave()
            
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            let tabbarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
            self.present(tabbarViewController, animated: true, completion: nil)
        }
   
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            configureViewComponents()
            loadUserData()
        }
    }
    
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = UIColor.googleRed()
        
        //navigationItem.title = "Login"
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.googleRed()
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}

