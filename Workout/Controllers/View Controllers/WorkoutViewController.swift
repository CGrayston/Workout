//
//  WorkoutViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/9/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var completedExercises: [CompletedExercise]?
    var program: Program?
    
    var completedWorkout: CompletedWorkout? {
        didSet {
            loadViewIfNeeded()
            tableView.reloadData()
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cylce Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
     
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedExercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "completedExerciseCell", for: indexPath) as? CompletedExerciseCellTableViewCell else { return UITableViewCell() }
        
        
        
        if let completedExercises = completedExercises {
            let completedExercise = completedExercises[indexPath.row]
            cell.completedExercise = completedExercise
            
//            cell.backgroundColor = exercise.isCompleted ? UIColor.green : UIColor.darkGray
//            print("Color: \(cell.backgroundColor?.description). Exercise isOn: \(exercise.isCompleted)")
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // ExerciseCellTableViewCell
        
        // "toExerciseView"
        if segue.identifier == "toExerciseView" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ExerciseViewController,
                let completedExercises = completedExercises else { return }
            
            // Get correct completedExercise to pass
            let completedExercise = completedExercises[indexPath.row]
            
            destinationVC.completedExerciseDelegate = self
            
            // Send completed workouts and exercises
            destinationVC.completedWorkout = completedWorkout
            destinationVC.completedExercise = completedExercise
//            // If exercise
//            if completedExercise.isCompleted {
//
//                destinationVC.workout = completedWorkout // not sure if this is neccesary
//                destinationVC.exercise = completedExercises
//            } else {
//                destinationVC.workout = completedWorkout // not sure if this is neccesary
//                destinationVC.exercise = completedExercises
//            }
        }
    }
    
    
    func updateViews() {
        guard let completedWorkout = completedWorkout else { return }
        workoutNameLabel.text = completedWorkout.name
        workoutDescriptionLabel.text = completedWorkout.description
        
    }
    
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        // Won't save anything
        
        // Dismiss current view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // TODO
        // Create a workout you did
//        guard let program = program, let workout = workout else { return }
//
//        // Save each exercise you did
//        CompletedWorkoutController.shared.createCompletedWorkout(program: program, workout: workout) { (success) in
//            if success {
//                self.dismiss(animated: true, completion: {
//                    let alert = UIAlertController(title: "Completed Workout!", message: "You can view this in the progress tab", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true)
//                })
//            }
//        }
        
    }
    
    

}


extension WorkoutViewController: CompletedExerciseDelegate {
    func completedExercise(completedExercise: CompletedExercise) {
        CompletedExerciseController.shared.exerciseIsCompleted(completedExercise: completedExercise)
    }
    
    
//    func completedExercise(exercise: Exercise) {
//        // Update model
//        ExerciseController.shared.exerciseIsCompleted(exercise: exercise)
//
//
//        tableView.reloadData()
//    }
}
