//
//  WrittenFeedbackController.swift
//  Graderr
//
//  Created by Sean Strong on 8/31/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class WrittenFeedbackController: UITableViewController {
    
    //var studentReviews = [Review]()
    
    var answersForDates = [(dateString: String , answers: Array<(key: String, value: String)>)]()
    var desiredField : Field?
    var isOverall : Bool = false
    var currentCourse : Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.prompt = desiredField?.title
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //        ReviewService.getReviews(forCourseID: currentCourse!.courseID, forSchoolID: currentCourse!.schoolID, completion: {(reviews) in
        //            guard let reviews = reviews else {
        //                return print("No reviews able to be retrieved, sadly :( ")
        //            }
        //            self.studentReviews = reviews
        //            self.tableView.reloadData()
        //
        //        })
        Utility.startLoading(view: self.view)
        if isOverall {
            ReviewService.getAllAnswers(forCourse: currentCourse!, forQuestion: desiredField!.title, completion: { (dict) in
                Utility.endLoading()
                guard let dict = dict as? [String : [String : String]]  else {
                    return print("getAnswers did not reveal any answers to the question asked...")
                }
                let dictArray = Array(dict).map({return (dateString: $0.key, answers: Array($0.value))})
                self.answersForDates = dictArray
                self.tableView.reloadData()


                
            })
            
        } else {
            ReviewService.getAnswers(forCourse: currentCourse!, forQuestion: desiredField!.title, completion: { (dict) in
                Utility.endLoading()
                guard let dict = dict as? [String : String]  else {
                    return print("getAnswers did not reveal any answers to the question asked...")
                }
                let value = (dateString: Utility.dateToString(), answers: Array(dict))
                self.answersForDates.append(value)
                self.tableView.reloadData()
  
                
            })
        }
        
        
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
        return answersForDates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return answersForDates[section].answers.count + 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! DateHeaderCell
            
            cell.dateStringLabel.text = answersForDates[indexPath.section].dateString
            return cell
        } else {
            let currentAnswer = answersForDates[indexPath.section].answers[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! WrittenContentCell
            StudentService.show(forUID: currentAnswer.key, completion: {(student) in
                guard let student = student else {
                    return print("Unable to get student id for selected review")
                }
                cell.nameLabel.text = student.name
            })
            
            cell.reviewContentLabel.text = currentAnswer.value
            
            
            return cell
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
