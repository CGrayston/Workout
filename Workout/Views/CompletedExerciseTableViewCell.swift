//
//  CompletedExerciseTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/11/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class CompletedExerciseCellTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var completedExercise: CompletedExercise? {
        didSet{
            updateCell()
        }
    }
    
    func updateCell() {
        guard let completedExercise = completedExercise else { return }
        
        nameLabel.text = completedExercise.name
        setsLabel.text = completedExercise.sets
        repsLabel.text = completedExercise.reps
        exerciseImageView.image = UIImage(named: "300-Pound-Bench")
        
        self.backgroundColor = completedExercise.isCompleted ? UIColor.green : UIColor.darkGray
        print("Color: \(self.backgroundColor?.description). Exercise isOn: \(completedExercise.isCompleted)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
}
