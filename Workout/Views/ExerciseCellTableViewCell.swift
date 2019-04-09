//
//  ExerciseCellTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ExerciseCellTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var exercise: Exercise? {
        didSet{
            updateCell()
        }
    }
    
    func updateCell() {
        guard let exercise = exercise else { return }
        
        nameLabel.text = exercise.name
        setsLabel.text = exercise.sets
        repsLabel.text = exercise.reps
        exerciseImageView.image = UIImage(named: "300-Pound-Bench")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
