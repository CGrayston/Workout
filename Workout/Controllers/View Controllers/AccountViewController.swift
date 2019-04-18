//
//  AccountViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    var window: UIWindow?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.googleRed()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }
    
    func updateViews() {
        guard let user = UserController.shared.currentUser else { return }
        usernameLabel.text = user.username
        emailLabel.text = user.email
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        handleSignOut()
    }
    
    func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserController.shared.currentUser = nil
            
//            let navController = UINavigationController(rootViewController: LoginController())
//            navController.navigationBar.barStyle = .black
//            self.present(navController, animated: true, completion: nil)
            window = UIWindow()
            window?.makeKeyAndVisible()
            let navController = UINavigationController(rootViewController: HomeController())
            navController.navigationBar.barStyle = .black
            window?.rootViewController = navController
            
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
}
