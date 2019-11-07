//
//  SearchedProgramTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/8/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class SearchedProgramTableViewCell: UITableViewCell {

    @IBOutlet weak var searchedProgramView: UIView!
    @IBOutlet weak var programPhotoImageView: UIImageView!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programDescription: UILabel!
    
    var program: Program? {
        didSet {
            updateCell()
        }
        
    }
    
    // TODO - do something with creator
    var creator: User?
    
    func updateCell() {
        guard let program = program else { return }
        programPhotoImageView.image = UIImage(named: "TheLogo")
        programNameLabel.text = program.name
        programDescription.text = program.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        searchedProgramView.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
