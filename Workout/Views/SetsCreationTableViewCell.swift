//
//  SetsCreationTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class SetsCreationTableViewCell: UITableViewCell {

    @IBOutlet weak var setLabel: UILabel!
    
    var setNumber: Int? {
        didSet{
            updateCell()
        }
    }
    
    func updateCell() {
        guard let setNumber = setNumber else { return }
        setLabel.text = "Set \(setNumber)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = UIColor.gray
        }
        // Configure the view for the selected state
    }
    
    
    
    
    
    

}
