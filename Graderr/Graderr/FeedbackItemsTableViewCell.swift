//
//  FeedbackItemsTableViewCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/28/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class FeedbackItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
