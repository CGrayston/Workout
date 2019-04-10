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
    var exercise: Exercise? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // Not sure if we need this
    var workout: Workout?
    
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
        return exercise?.setsCount ?? 0
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
        guard let exercise = exercise else { return }
        exerciseNameLabel.text = exercise.name
        setsLabel.text = exercise.sets
        repsLabel.text = exercise.reps
        
        exerciseImageView.image = UIImage(named: "300-Pound-Bench")
        
    }
    
    // MARK: - IBOutlets
    @IBAction func cancelButtonTapped(_ sender: Any) {
        // Dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Save information
        
        // Delegate method to show you have completed that exercise
        
        // Dismiss view
    }
    
    @IBAction func exerciseHistoryButtonTapped(_ sender: Any) {
        // View other times you did this exercise
    }
}
