//
//  ProgressTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/16/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    
    var completedWorkout: CompletedWorkout? {
        didSet {
            self.updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutSubviews()
        backgroundCellView.layer.cornerRadius = 5
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
    
    
    // MARK: - Helper Function
    func updateCell() {
        guard let completedWorkout = completedWorkout else { return }
        DispatchQueue.main.async {
            self.dateLabel.text = DateHelper.dateFormatter.string(from: completedWorkout.dateCompleted)
            self.programLabel.text = completedWorkout.programName
            self.workoutLabel.text = completedWorkout.name
        }
    }
}
