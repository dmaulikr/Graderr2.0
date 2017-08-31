//
//  QuestionCreationCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/30/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class QuestionCreationCell: UITableViewCell {

    @IBOutlet weak var questionTypeImageView: UIImageView!
    
    @IBOutlet weak var questionContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
