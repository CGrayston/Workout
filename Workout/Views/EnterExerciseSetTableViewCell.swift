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
        guard let set = set else { return }
        setLabel.text = "Set \(set)"
    }

    
}
