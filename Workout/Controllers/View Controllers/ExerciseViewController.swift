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
        cell.set = indexPath.row + 1
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        // Dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Save information
        let setRows = tableView.numberOfRows(inSection: 0)
       
        //tableView.cellForRow(at: <#T##IndexPath#>)
        
        // Delegate method to show you have completed that exercise
        guard let completedExercise = completedExercise else { return }
        
        completedExerciseDelegate?.completedExercise(completedExercise: completedExercise)
        
        // Dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exerciseHistoryButtonTapped(_ sender: Any) {
        // View other times you did this exercise
    }
}

protocol CompletedExerciseDelegate: class {
    func completedExercise(completedExercise: CompletedExercise)
}
