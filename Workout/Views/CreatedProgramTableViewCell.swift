//
//  CreatedProgramTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class CreatedProgramTableViewCell: UITableViewCell {

    @IBOutlet weak var programImageView: UIImageView!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    
    var program: Program? {
        didSet {
            //self.setSelected(, animated: <#T##Bool#>)
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        
        guard let program = program else { return }
        
        if program.photoURL == "" {
            programImageView.image = UIImage(named: "300-Pound-Bench")
        } else {
            // TODO
        }
        
        programNameLabel.text = program.name
        programDescriptionLabel.text = program.description
    }

}
