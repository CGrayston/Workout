//
//  CompletedExerciseViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/15/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class CompletedExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    // MARK: - Properties
    var completedExercise: CompletedExercise? {
        didSet {
            loadViewIfNeeded()
            uploadViews()
            tableView.reloadData()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 75
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedExercise?.setsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "completedSetCell", for: indexPath) as? CompletedSetTableViewCell,
            let completedExercise = completedExercise
            else { return UITableViewCell() }
        
        cell.set = indexPath.row
        cell.completedExercise = completedExercise
        
        return cell
    }
    
    
    // MARK: - Helper Methods
    func uploadViews() {
        guard let completedExercise = completedExercise else { return }
        exerciseNameLabel.text = completedExercise.name
        exerciseImageView.image = UIImage(named: "300-Pound-Bench")
        setsLabel.text = completedExercise.sets
        repsLabel.text = completedExercise.reps
        
    }
    @IBAction func historyButtonTapped(_ sender: Any) {
        let displayVC : ExerciseHistoryViewController = UIStoryboard(name: "MyPrograms", bundle: nil).instantiateViewController(withIdentifier: "ExerciseHistory") as! ExerciseHistoryViewController
        
        guard let completedExercise = completedExercise else { return }
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        CompletedExerciseController.shared.fetchExerciseHistory(with: completedExercise) { (completedExercises) -> (Void) in
            // Pass history to next tab
            if completedExercises.count < 1 {
                return
            } else {
                displayVC.completedExercises = completedExercises
                dispatchGroup.leave()
                self.present(displayVC, animated: true, completion: nil)
            }
        }
    }
    
}
