//
//  PollSubmissionTableViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/28/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class PollSubmissionTableViewController: UITableViewController {
    
    var currentCourse : Course?
    var fields : [Field] = [Field]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        let review = Review(reviewID: Utility.newFirebaseKey(), studentID: Student.current.studentID, courseID: currentCourse!.courseID, schoolID: currentCourse!.schoolID, fields: self.fields)
        ReviewService.submitReview(review: review, success: {(success) in
            print(success ? "Uploaded review to database correctly!" : "Error uploading review to database")
        })
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionService.getQuestions(forCourse: currentCourse!, completion: {(fields) in
            guard let fields = fields else {
                print("Unable to obtain questions succesfully for the given course")
                return
            }
            self.fields = fields
        })
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fields.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentField = fields[indexPath.row]
        switch currentField.fieldType! {
        case .bool:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bool", for: indexPath) as! BoolFieldTableViewCell
            cell.delegate = self
            cell.row = indexPath.row
            cell.questionText.text = currentField.title
            return cell
            
        case .numeric:
            let cell = tableView.dequeueReusableCell(withIdentifier: "numeric", for: indexPath) as! NumericFieldTableViewCell
            cell.delegate = self
            cell.row = indexPath.row
            cell.questionText.text = currentField.title
            return cell
            
        case .written:
            let cell = tableView.dequeueReusableCell(withIdentifier: "written", for: indexPath) as! WrittenFieldTableViewCell
            
            cell.delegate = self
            cell.row = indexPath.row
            cell.questionText.text = currentField.title
            return cell
        }

    }
    
    
    
}

extension PollSubmissionTableViewController : BoolFieldTableViewCellDelegate {
    func didTapTrueButton(_ trueButton: UIButton, on cell: BoolFieldTableViewCell) {
        cell.falseButton.backgroundColor = UIColor.gray
        cell.trueButton.backgroundColor = UIColor.green
        fields[cell.row!].value = true
    }
    
    func didTapFalseButton(_ falseButton: UIButton, on cell: BoolFieldTableViewCell) {
        fields[cell.row!].value = false
        cell.falseButton.backgroundColor = UIColor.red
        cell.trueButton.backgroundColor = UIColor.gray
    }
}

extension PollSubmissionTableViewController : NumericFieldTableViewCellDelegate {
    func didTapNumberButton(_ numberButton: UIButton, on cell: NumericFieldTableViewCell) {
        fields[cell.row!].value = numberButton.tag
        
    }
}

extension PollSubmissionTableViewController : WrittenFieldTableViewCellDelegate {
    func didEditText(_ textField: UITextField, on cell: WrittenFieldTableViewCell) {
        fields[cell.row!].value = textField.text
    }
}
