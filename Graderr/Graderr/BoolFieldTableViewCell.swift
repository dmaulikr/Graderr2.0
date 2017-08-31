//
//  BoolFieldTableViewCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/28/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

protocol BoolFieldTableViewCellDelegate: class {
    func didTapTrueButton(_ trueButton: UIButton, on cell: BoolFieldTableViewCell)
    func didTapFalseButton(_ falseButton: UIButton, on cell: BoolFieldTableViewCell)
}


class BoolFieldTableViewCell: UITableViewCell {
    
    weak var delegate: BoolFieldTableViewCellDelegate?
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var falseImageView: UIImageView!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueImageView: UIImageView!
    @IBOutlet weak var trueButton: UIButton!
    
    var row : Int?
    
    @IBAction func trueButtonPressed(_ sender: UIButton) {
        delegate?.didTapTrueButton(sender, on: self)
        
    }
    
    @IBAction func falseButtonPressed(_ sender: UIButton) {
        delegate?.didTapFalseButton(sender, on: self)
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
