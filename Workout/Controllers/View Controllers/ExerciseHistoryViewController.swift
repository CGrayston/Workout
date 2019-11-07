//
//  ExerciseHistoryViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/15/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ExerciseHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Properties
    var completedExercises: [CompletedExercise]? {
        didSet {
            loadViewIfNeeded()
            updateViews()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UIScreen.main.bounds.height * 0.08
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return completedExercises?.count ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let completedExercise = completedExercises?[section] else { return "Past Workout" }
        return DateHelper.dateFormatter.string(from: completedExercise.dateCompleted)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let completedExercise = completedExercises?[section] else { return 0 }
        return completedExercise.setsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "completedSetCell", for: indexPath) as? CompletedSetTableViewCell,
            let completedExercise = completedExercises?[indexPath.section]
            else { return UITableViewCell() }
        cell.set = indexPath.row
        cell.completedExercise = completedExercise
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // MARK: - Helper Methods
    func updateViews() {
        guard let completedExercise = completedExercises?.first else { return }
        
        exerciseNameLabel.text = completedExercise.name
        exerciseImageView.image = UIImage(named: "TheLogo")
        setsLabel.text = completedExercise.sets
        repsLabel.text = completedExercise.reps
        
    }
    
    // toExerciseHistory
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Dismiss View
        self.dismiss(animated: true, completion: nil)
    }
    
}
