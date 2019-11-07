//
//  ProgramViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/9/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ProgramViewController: UIViewController {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programImageView: UIImageView!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    
    var program: Program? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var workouts: [Workout] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Resign keyboard on tap
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        programDescriptionLabel.sizeToFit()
    }
    

    func updateViews() {
        guard let program = program else { return }
        programNameLabel.text = program.name
        
        programDescriptionLabel.text = program.description
        
        if program.photoURL == "" {
            programImageView.image = UIImage(named: "TheLogo")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toChooseWorkoutVC" {
            
            // Set destination
            guard let destinationVC = segue.destination as? ChooseWorkoutViewController else { return }
            // Send the workouts over
            destinationVC.workouts = workouts
            // Send the program over
            destinationVC.program = program

        }
    }
 

    @IBAction func startButtonTapped(_ sender: Any) {
        // TODO
        // Get workouts associated with current program
        
        guard let program = program else { return }
        WorkoutController.shared.getWorkoutsForProgram(program) { (workouts) -> (Void) in
            
            self.workouts = workouts
            
            // Push to ChooseWorkoutViewController
            //self.present(destinationVC, animated: true)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toChooseWorkoutVC", sender: self)
            }
            
        
        }
        

    }
    
    
}
