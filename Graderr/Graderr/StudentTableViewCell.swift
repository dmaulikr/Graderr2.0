//
//  StudentTableViewCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/22/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!
    
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    @IBOutlet weak var haveTakenClassLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
