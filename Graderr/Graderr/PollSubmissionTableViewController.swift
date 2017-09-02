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
        
        
        for field in fields {
            if field.value == nil {
                Utility.createAlert(title: "You have not filled out all fields.", message: "Please fill out every field, then press submit.", sender: self)
                return
            }
        }
        
        Utility.startLoading(view: self.view)
        let review = Review(reviewID: Utility.newFirebaseKey(), studentID: Student.current.studentID, courseID: currentCourse!.courseID, schoolID: currentCourse!.schoolID, fields: self.fields)
        ReviewService.submitReview(review: review, success: {(success) in
            Utility.endLoading()
            print(success ? "Uploaded review to database correctly!" : "Error uploading review to database")
            if success {
                self.navigationController?.popViewController(animated: true)
                Utility.createAlert(title: "Success.", message: "Submitted review succesfully.", sender: self.navigationController!.topViewController!)
            } else {
                Utility.createAlert(title: "Error", message: "Issue uploading review to database.", sender: self)
            }

            


            
        })
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.startLoading(view: self.view)
        QuestionService.getCustomQuestions(forCourse: currentCourse!, completion: {(fields) in
            Utility.endLoading()    
            guard let fields = fields else {
                print("Unable to obtain questions succesfully for the given course")
                self.navigationController?.popViewController(animated: true)
                Utility.createAlert(title: "Error", message: "Your teacher has not yet inputted questions for today's class.", sender: self.navigationController!.topViewController!)
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
        
        
        cell.falseImageView.image = UIImage(named: "NoEmpty")
        cell.trueImageView.image = UIImage.init(named: "YesFilled")
        fields[cell.row!].value = true
    }
    
    func didTapFalseButton(_ falseButton: UIButton, on cell: BoolFieldTableViewCell) {
        fields[cell.row!].value = false
        cell.falseImageView.image = UIImage(named: "NoFilled")
        cell.trueImageView.image = UIImage.init(named: "YesEmpty")

    }
}

extension PollSubmissionTableViewController : NumericFieldTableViewCellDelegate {
    func didTapNumberButton(_ numberButton: UIButton, on cell: NumericFieldTableViewCell) {
        fields[cell.row!].value = numberButton.tag
        switch numberButton.tag { //could use a for loop here if this is slow
        case 1:
            cell.selectedImageViewCollection[0].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[1].image = UIImage(named:"CircleEmpty")
            cell.selectedImageViewCollection[2].image = UIImage(named:"CircleEmpty")
            cell.selectedImageViewCollection[3].image = UIImage(named:"CircleEmpty")
            cell.selectedImageViewCollection[4].image = UIImage(named:"CircleEmpty")
        case 2:
            cell.selectedImageViewCollection[0].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[1].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[2].image = UIImage(named:"CircleEmpty")
            cell.selectedImageViewCollection[3].image = UIImage(named:"CircleEmpty")
            cell.selectedImageViewCollection[4].image = UIImage(named:"CircleEmpty")
        case 3:
            cell.selectedImageViewCollection[0].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[1].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[2].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[3].image = UIImage(named:"CircleEmpty")
            cell.selectedImageViewCollection[4].image = UIImage(named:"CircleEmpty")
        case 4:
            cell.selectedImageViewCollection[0].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[1].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[2].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[3].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[4].image = UIImage(named:"CircleEmpty")
        case 5:
            cell.selectedImageViewCollection[0].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[1].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[2].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[3].image = UIImage(named:"CircleFilled")
            cell.selectedImageViewCollection[4].image = UIImage(named:"CircleFilled")
        default:
            fatalError("Unable to access all image views correctly, passed in index is out of bounds")
        
        }
        
    }
}

extension PollSubmissionTableViewController : WrittenFieldTableViewCellDelegate {
    func didEditText(_ textField: UITextField, on cell: WrittenFieldTableViewCell) {
        fields[cell.row!].value = textField.text
    }
}
