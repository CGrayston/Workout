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
    
    // MARK: - Selectors
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docRef = db.collection(DatabaseReference.userDatabase).document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let username = document["username"] as? String else { return }
                self.welcomeLabel.text = "Welcome, \(username)"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.welcomeLabel.alpha = 1
                })
                // Present Main Tabbar
//                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
//                guard let controller = navController.viewControllers[0] as? HomeController else { return }
//
//                let tabbarViewController = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "Tabbar")
//
//                guard let tabController = UIApplication.shared.keyWindow?.resignKey() as UITabBarController else { return }
//                guard let controller = tabBarController?.viewControllers[0] as
//
//                if let tabBar = self.tabBarController {
//
//                    self.present(tabBar, animated: true, completion: nil)
//                }
                let tabbarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
                self.present(tabbarViewController, animated: true, completion: nil)
                
            } else {
                print("Document does not exist")
            }
        }
        
        //guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
        //guard let controller = navController.viewControllers[0] as? HomeController else { return }
        
        //controller.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
        
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
        view.backgroundColor = UIColor.mainBlue()
        
        navigationItem.title = "Firebase Login"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}

