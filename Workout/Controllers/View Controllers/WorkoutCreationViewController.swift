//
//  WorkoutCreationViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class WorkoutCreationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var workoutDescriptionTextView: UITextView!
    
    // MARK: - Landing Pad
    var workout: Workout? {
        didSet {
            loadViewIfNeeded()
            // Update Views
            updateViews()
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.hideKeyboardWhenTappedAround()
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let workoutUID = workout?.uid else { return }
        ExerciseController.shared.loadExercises(workoutUID: workoutUID) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        guard let workoutUID = workout?.uid else { return }
//        ExerciseController.shared.loadExercises(workoutUID: workoutUID) {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    
    func updateViews() {
        guard let workout = workout  else { return }
        workoutNameTextField.text = workout.name
        workoutDescriptionTextView.text = workout.description
    }
    
    
    // MARK: - TableView Delgate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ExerciseController.shared.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as? ExerciseCellTableViewCell else { return UITableViewCell() }
        
        
        let exercise = ExerciseController.shared.exercises[indexPath.row]
        cell.exercise = exercise
        
        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let workoutUID = workout?.uid else { return }
        // Declare empty workout to assign if user creates a new workout
        var exercise: Exercise?
        
        // User clicked on the "+" bar button item
        if segue.identifier == "toCreateExerciseVC" {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            ExerciseController.shared.createExercise(workoutUID: workoutUID) { (success, createdExercise) in
                if success {
                    print("Success creating new exercise. Should push")
                    
                    exercise = createdExercise
                    dispatchGroup.leave()
                } else {
                    print("Failure creating blank Exercise, still will push?")
                }
            }
            
            // Pass Program we jsut created to CreateNewProgramVC
            dispatchGroup.notify(queue: .main) {
                guard let destinationVC = segue.destination as? ExerciseCreationViewController
                    else { return }
                
                // Pass workout we got from createWorkout call to the next VC
                guard let exercise = exercise else { return }
                destinationVC.exercise = exercise
            }
        }
        
        // User clicked on a created Program in tableView
        if segue.identifier == "toShowExerciseVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ExerciseCreationViewController
                else { return }
            
            // Pass program we got from tableView to the next VC
            let exercise = ExerciseController.shared.exercises[indexPath.row]
            destinationVC.exercise = exercise
        }
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let exercise = ExerciseController.shared.exercises[indexPath.row]
            
            ExerciseController.shared.deleteExercise(exercise: exercise) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // MARK: - Actions
    @IBAction func saveWorkoutInfoButton(_ sender: Any) {
        // Update workout information in Firestore
        guard let workout = workout,
            let name = workoutNameTextField.text,
            let description = workoutDescriptionTextView.text else { return }
        
        WorkoutController.shared.updateWorkout(workout: workout, name: name, description: description) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                // TODO
                fatalError("Error updating workout")
            }
        }
    }
    
}
