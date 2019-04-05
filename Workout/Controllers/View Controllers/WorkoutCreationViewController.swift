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
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    // MARK: - Landing Pad
    var workout: Workout? {
        didSet {
            loadViewIfNeeded()
            // Update Views
            updateViews()
        }
    }
    
    func updateViews() {
        guard let workout = workout  else { return }
        workoutNameTextField.text = workout.name
        workoutDescriptionTextView.text = workout.description
    }
    
    
    // MARK: - TableView Delgate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 // TODO
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
