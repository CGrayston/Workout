//
//  WorkoutTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/18/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutDescriptionLabel: UILabel!
    
    var workout: Workout? {
        didSet {
            layoutIfNeeded()
            updateWorkoutCell()
        }
    }
    
    var completedWorkout: CompletedWorkout? {
        didSet {
            updatecompletedWorkoutCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if backgroundCellView != nil {
            backgroundCellView.layer.cornerRadius = 5
        }
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWorkoutCell() {
        guard let workout = workout else { return }
        workoutNameLabel.text = workout.name
        workoutDescriptionLabel.text = workout.description
    }
    
    func updatecompletedWorkoutCell() {
        guard let completedWorkout = completedWorkout else { return }
        workoutNameLabel.text = completedWorkout.name
        workoutDescriptionLabel.text = completedWorkout.description
    }

}
