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
    var exercises: [Exercise]?
    
    var workout: Workout? {
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
        return exercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as? ExerciseCellTableViewCell else { return UITableViewCell() }
        
        if let exercises = exercises {
            let exercise = exercises[indexPath.row]
            cell.exercise = exercise
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
                let exercises = exercises else { return }
            
            let exercise = exercises[indexPath.row]
            
            destinationVC.workout = workout // not sure if this is neccesary
            destinationVC.exercise = exercise
        }
    }
    
    
    func updateViews() {
        guard let workout = workout else { return }
        workoutNameLabel.text = workout.name
        workoutDescriptionLabel.text = workout.description
        
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
        
        // Save each exercise you did
        
    }
    
    

}
