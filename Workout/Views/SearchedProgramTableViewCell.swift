//
//  SearchedProgramTableViewCell.swift
//  Workout
//
//  Created by Chris Grayston on 4/8/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class SearchedProgramTableViewCell: UITableViewCell {

    @IBOutlet weak var programPhotoImageView: UIImageView!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programCreatorLabel: UILabel!
    
    var program: Program? {
        didSet {
            updateCell()
        }
    }
    
    // TODO - do something with creator
    var creator: User?
    
    func updateCell() {
        guard let program = program else { return }
        programPhotoImageView.image = UIImage(named: "300-Pound-Bench")
        programNameLabel.text = program.name
        programCreatorLabel.text = "By: \(program.creatorUID)"
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
