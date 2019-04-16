//
//  EnterExerciseSetTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/9/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class EnterExerciseSetTableViewCell: UITableViewCell {

    // MARK: - Properties
    var completedExercise: CompletedExercise?
    
    var set: Int? {
        didSet{
            updateCell()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightInputTextField: UITextField!
    @IBOutlet weak var repsInputTextField: UITextField!
    
    
    func updateCell() {
        guard let set = set,
            let completedExercise = completedExercise
            else { return }
        
        setLabel.text = "Set \(set)"
        if completedExercise.weightsCompleted.isEmpty {
            weightInputTextField.text = ""
            weightInputTextField.placeholder = "Weight..."
        } else {
            weightInputTextField.text = "\(completedExercise.weightsCompleted[set - 1])"
        }
        
        if completedExercise.repsCompleted.isEmpty {
            weightInputTextField.text = ""
            weightInputTextField.placeholder = "Weight..."
        } else {
            repsInputTextField.text = "\(completedExercise.repsCompleted[set - 1])"
        }
        
    }
    
    func getWeightInput() -> Double {
        guard let weightInputTextField = weightInputTextField, let weight = Double(weightInputTextField.text!) else { return 0 }
        return weight
    }
    
    func getRepsInput() -> Int {
        guard let repsInputTextField = repsInputTextField, let reps = Int(repsInputTextField.text!) else { return 0 }
        return reps
    }
    
    

    
}
