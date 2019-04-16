//
//  ExerciseViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/10/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var completedExercise: CompletedExercise? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var cells: [EnterExerciseSetTableViewCell] = []
    
    // Not sure if we need this
    var completedWorkout: CompletedWorkout?
    
    weak var completedExerciseDelegate: CompletedExerciseDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 80
        
        // Resign keyboard on tap
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedExercise?.setsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as? EnterExerciseSetTableViewCell else { return UITableViewCell() }
        
        cell.completedExercise = completedExercise
        cell.set = indexPath.row + 1
        
        // add cell to cells array to be used later
        if(!cells.contains(cell)){
            self.cells.append(cell)
        }
        
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toExerciseHistoryVC" {
            // Get history
            guard let completedExercise = completedExercise,
                let destinationVC = segue.destination as? ExerciseHistoryViewController
                else { return }
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            CompletedExerciseController.shared.fetchExerciseHistory(with: completedExercise) { (completedExercises) -> (Void) in
                // Pass history to next tab
                if completedExercises.count < 1 {
                    return
                } else {
                    destinationVC.completedExercises = completedExercises
                    dispatchGroup.leave()
                }
            }
        }
    }
 

    // MARK: - Helper Methods
    func updateViews() {
        guard let completedExercise = completedExercise else { return }
        exerciseNameLabel.text = completedExercise.name
        setsLabel.text = completedExercise.sets
        repsLabel.text = completedExercise.reps
        
        exerciseImageView.image = UIImage(named: "300-Pound-Bench")
        
    }
    
    // MARK: - IBOutlets
    @IBAction func cancelButtonTapped(_ sender: Any) {
        // Delete all completed workouts from completedWorkouts Database
        
        // CompletedWorkout should never have been put in datbase
        
        
        // Dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    /*
     * This will just save it locally so they can still adjust the value later if they messed soemthing up.
     * Everything can be saved to Firestore with the save button on the WorkoutVC
     */
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Save information to the completedExercise
        guard let completedExercise = completedExercise else { return }
        
        // Initial arrays to populate
        var weightsCompleted: [Double] = []
        var repsCompleted: [Int] = []
       
        // Iterate through all cells that we saved when population tableView
        for cell in cells {
            // Add values to our local weight and reps arrays
            weightsCompleted.append(cell.getWeightInput())
            repsCompleted.append(cell.getRepsInput())
        }
        
        // Save the completedExercise information locally in CompletedExerciseController - mark isComplete = true
        
        CompletedExerciseController.shared.updateExerciseWeightAndRepsValuesLocally(completedExercise: completedExercise, weightsCompleted: weightsCompleted, repsCompleted: repsCompleted)
        
        
        
//        // TODO - Not sure if we need below code
//        // Delegate method to show you have completed that exercise
//        guard let completedExercise = completedExercise else { return }
//
//        completedExerciseDelegate?.completedExercise(completedExercise: completedExercise)
        
        // Dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exerciseHistoryButtonTapped(_ sender: Any) {
        // Search CompletedExerciseDB for exerciseUID == exerciseUID
//        guard let completedExercise = completedExercise else { return }
//        CompletedExerciseController.shared.fetchExerciseHistory(with: completedExercise) { (completedExercises) -> (Void) in
//            <#code#>
//        }
        
//        guard let completedExercise = completedExercise
//
//            else { return }
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        CompletedExerciseController.shared.fetchExerciseHistory(with: completedExercise) { (completedExercises) -> (Void) in
//            // Pass history to next tab
//            if completedExercises.count < 1 {
//                return
//            } else {
//                let destinationVC = ExerciseHistoryViewController()
//                destinationVC.completedExercises = completedExercises
//                self.performSegue(withIdentifier: "ExerciseHistoryViewController", sender: self)
//                dispatchGroup.leave()
//            }
//        }
        
        
        // the name for UIStoryboard is the file name of the storyboard without the .storyboard extension
        let displayVC : ExerciseHistoryViewController = UIStoryboard(name: "MyPrograms", bundle: nil).instantiateViewController(withIdentifier: "ExerciseHistory") as! ExerciseHistoryViewController
        
        guard let completedExercise = completedExercise else { return }
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        CompletedExerciseController.shared.fetchExerciseHistory(with: completedExercise) { (completedExercises) -> (Void) in
            // Pass history to next tab
            if completedExercises.count < 1 {
                let alert = UIAlertController(title: "You havent completed this exercise yet!", message: "After you finish this workout it will appear in your history", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
                
                return
            } else {
                displayVC.completedExercises = completedExercises
                dispatchGroup.leave()
                self.present(displayVC, animated: true, completion: nil)
            }
        }
        
        
    }
}

protocol CompletedExerciseDelegate: class {
    func completedExercise(completedExercise: CompletedExercise)
}
