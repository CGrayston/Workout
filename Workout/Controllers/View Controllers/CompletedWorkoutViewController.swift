//
//  CompletedWorkoutViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/15/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class CompletedWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: - Properties
    var completedExercises: [CompletedExercise]?
    
    var completedWorkout: CompletedWorkout? {
        didSet {
            loadViewIfNeeded()
            tableView.reloadData()
            updateViews()
        }
    }
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UIScreen.main.bounds.height * 0.2
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCompletedExerciseVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let completedExercise = completedExercises?[indexPath.row],
                let destinationVC = segue.destination as? CompletedExerciseViewController
                else { return }
            
            destinationVC.completedExercise = completedExercise
        }
    }
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedExercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "completedExerciseCell", for: indexPath) as? CompletedExerciseCellTableViewCell, let completedExercise = completedExercises?[indexPath.row] else { return UITableViewCell() }
        
        cell.completedExercise = completedExercise
        
        return cell
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let completedWorkout = completedWorkout else { return }
        workoutNameLabel.text = completedWorkout.name
        workoutDescriptionLabel.text = completedWorkout.description
        
    }

}
