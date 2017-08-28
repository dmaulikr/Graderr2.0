//
//  NumericFieldTableViewCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/28/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

protocol NumericFieldTableViewCellDelegate: class {
    func didTapNumberButton(_ numberButton: UIButton, on cell: NumericFieldTableViewCell)
}

class NumericFieldTableViewCell: UITableViewCell {
    
    weak var delegate: NumericFieldTableViewCellDelegate?
    
    @IBOutlet weak var questionText: UILabel!
    
    var row : Int?
    
    
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        delegate?.didTapNumberButton(sender, on: self)
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
