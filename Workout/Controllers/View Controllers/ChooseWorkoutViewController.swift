//
//  ChooseWorkoutViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/9/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ChooseWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var workouts: [Workout]?
    
    var program: Program? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let workouts = workouts else { return }
        self.workouts = workouts
        // Set delegate and sta source
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        
        // Resign keyboard on tap
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let workouts = workouts else { return }
        self.workouts = workouts
    }
    
    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workouts = workouts else { return 0 }
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutSelectionCell", for: indexPath) as? WorkoutTableViewCell,
            let workout = workouts?[indexPath.row]
            else { return UITableViewCell() }
        //guard   else { return cell }
        
        cell.workout = workout
//        cell.textLabel?.text = workouts[indexPath.row].name
//        cell.detailTextLabel?.text = workouts[indexPath.row].description
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toWorkoutViewController" {
            let dispatchGroup = DispatchGroup()
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                let workouts = workouts,
                let destinationVC = segue.destination as? WorkoutViewController
                else { return }
            
            let workout = workouts[indexPath.row]
            dispatchGroup.enter()
            
            
            // Create an initial completedWorkout
            guard let program = program else { return }
            let completedWorkout = CompletedWorkoutController.shared.createInitialCompletedWorkout(program: program, workout: workout)
            
            // Create initial exercises based off that initial completedWorkout and pass them
            CompletedExerciseController.shared.createInitialCompletedExercisesFromWorkout(workout, completedWorkout: completedWorkout) { (success) -> (Void) in
//                dispatchGroup.leave()
//                // Pass values to WorkoutViewController
//                dispatchGroup.notify(queue: .main, execute: {
//                    destinationVC.completedExercises = completedExercises
//                    destinationVC.program = self.program
//                    destinationVC.completedWorkout = completedWorkout
//                })
                
                if success {
                    //destinationVC.completedExercises = completedExercises
                    destinationVC.program = self.program
                    destinationVC.completedWorkout = completedWorkout
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let program = program else { return }
        programNameLabel.text = program.name
        
        programDescriptionLabel.text = program.description
        
    }
    
    
}
