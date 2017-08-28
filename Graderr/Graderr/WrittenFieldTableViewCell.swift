//
//  WrittenFieldTableViewCell.swift
//  Graderr
//
//  Created by Sean Strong on 8/28/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

protocol WrittenFieldTableViewCellDelegate: class {
    func didEditText(_ textField: UITextField, on cell: WrittenFieldTableViewCell)
}

class WrittenFieldTableViewCell: UITableViewCell {
    
    weak var delegate: WrittenFieldTableViewCellDelegate?
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        delegate?.didEditText(sender, on: self)
    }
    
    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    var row : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
