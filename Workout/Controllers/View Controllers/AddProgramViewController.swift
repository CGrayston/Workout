//
//  AddProgramViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/8/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class AddProgramViewController: UIViewController {
    
    // MARK: - Properties
    var program: Program? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programImageView: UIImageView!
    @IBOutlet weak var programDescription: UILabel!
    @IBOutlet weak var followProgramButton: UIButton!
    @IBOutlet weak var unfollowBarButtonItem: UIBarButtonItem!
    
    // MARK: - Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resign keyboard on tap
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let program = program, let currentUser = UserController.shared.currentUser else { return }
       
        if currentUser.followedPrograms.contains(program.uid) {
            // Already following
            DispatchQueue.main.async {
                self.followProgramButton.setTitle("Already Following", for: .disabled)
                //self.followProgramButton.backgroundColor = UIColor.blue
                self.followProgramButton.titleLabel?.textColor = UIColor.white
                self.followProgramButton.isEnabled = false
                self.unfollowBarButtonItem.isEnabled = true
            }
        } else {
            // Not following
            DispatchQueue.main.async {
                self.followProgramButton.setTitle("Follow Program", for: .normal)
                //self.followProgramButton.backgroundColor = UIColor.googleRed()
                self.followProgramButton.titleLabel?.textColor = UIColor.white
                self.followProgramButton.isEnabled = true
                self.unfollowBarButtonItem.isEnabled = false
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func followProgramButtonTapped(_ sender: Any) {
        followProgram()
    }
    
    @IBAction func unfollowButtonTapped(_ sender: Any) {
        handleUnfollow()
    }
    
    
    // MARK: - Helper Functions
    func handleUnfollow() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to unfollow?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Unfollow Program", style: .destructive, handler: { (_) in
            self.unfollowProgram()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func followProgram() {
        // Follow program
        guard let program = program else { return}
        
        // Append Program's 'uid' to User's 'followedPrograms' array
        // Append User's 'uid' to Program's --> 'followersUIDs'
        UserController.shared.followProgram(program: program) { (success, response) -> (Void) in
            // Send reload notification if we unfollowed
            if success {
                ProgramController.shared.setUserFollowedAndCreatedPrograms(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NotificationCenterNames.programUpdated, object: nil)
                    }
                })
            }
            
            if success && response == "Following program" {
                DispatchQueue.main.async {
                    self.followProgramButton.isEnabled = false
                    self.unfollowBarButtonItem.isEnabled = true

                    
                    //self.followProgramButton.backgroundColor = UIColor.blue
                    self.followProgramButton.titleLabel?.textColor = UIColor.white
                    self.followProgramButton.setTitle("Following Program", for: .disabled)
                }
            } else if success && response == "Already Following" {
                DispatchQueue.main.async {
                    self.followProgramButton.isEnabled = false
                    self.unfollowBarButtonItem.isEnabled = true
                    
                    
                    //self.followProgramButton.backgroundColor = UIColor.blue
                    self.followProgramButton.titleLabel?.textColor = UIColor.white
                    self.followProgramButton.setTitle("Already Following Program", for: .disabled)
                }
            }  else {
                DispatchQueue.main.async {
                    //self.followProgramButton.backgroundColor = UIColor.googleRed()
                    self.followProgramButton.titleLabel?.textColor = UIColor.white
                    self.followProgramButton.titleLabel?.text = response
                }
            }
        }
    }
    
    func unfollowProgram() {
        guard let program = program else { return }
        
        UserController.shared.unfollowProgram(program: program) { (success, response) -> (Void) in
            print("Success: \(success). Response \(response)")
            DispatchQueue.main.async {
                self.followProgramButton.isEnabled = true
                self.unfollowBarButtonItem.isEnabled = false
                
                
                //self.followProgramButton.backgroundColor = UIColor.googleRed()
                self.followProgramButton.titleLabel?.textColor = UIColor.white
                self.followProgramButton.setTitle("Follow Program", for: .normal)
            }
            if success {
                ProgramController.shared.setUserFollowedAndCreatedPrograms(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NotificationCenterNames.programUpdated, object: nil)
                    }
                })
            }
        }
        
    }
    
    func updateViews() {
        guard let program = program else { return }
        
        programNameLabel.text = program.name
        programDescription.text = program.description
        programImageView.image = UIImage(named: "300-Pound-Bench")
    }
    
}
