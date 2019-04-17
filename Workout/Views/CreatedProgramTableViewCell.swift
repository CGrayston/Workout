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
            DispatchQueue.main.async {
                self.programImageView.downloaded(from: program.photoURL)
                
            }
        }
        
        programNameLabel.text = program.name
        programDescriptionLabel.text = program.description
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
