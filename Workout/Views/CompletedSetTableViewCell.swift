//
//  CompletedSetTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/15/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class CompletedSetTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var set: Int?
    
    var completedExercise: CompletedExercise? {
        didSet {
            updateCell()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var setCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCellView.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.selectionStyle = .none
    }
    
    // MARK: - Helper Methods
    func updateCell() {
        guard let set = set,
            let completedExercise = completedExercise
            else { return }
        
        setLabel.text = "Set \(set + 1)"
        weightLabel.text = "\(completedExercise.weightsCompleted[set])"
        repsLabel.text = "\(completedExercise.repsCompleted[set])"
    }
    
}
