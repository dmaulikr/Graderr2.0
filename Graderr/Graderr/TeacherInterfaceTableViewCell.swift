//
//  TeacherInterfaceTableViewCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/22/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class TeacherInterfaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!
    
    @IBOutlet weak var studentsCompletedPollLabel: UILabel!
    
    @IBOutlet weak var totalStudentsLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
