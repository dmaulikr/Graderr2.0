//
//  TeacherInterfaceTableViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/22/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class TeacherInterfaceTableViewController: UITableViewController {
    
    @IBAction func logOut(_ sender: Any) {
        Utility.logOut(success: {(success) in
            if success {
                let initialViewController = UIStoryboard(name: "Login", bundle: .main).instantiateInitialViewController()
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                Utility.createAlert(title: "Error", message: "Unable to sign out successfully at this time.", sender: self)
            }
        })
    }
    var coursesTaught = [Course]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        TeacherService.showCoursesTeaching(forTeacher: Teacher.current, completion: {(courses) in
            self.coursesTaught = courses ?? []
            dispatchGroup.leave()
            
        })
        
        //note, coursesTaught at index 0 is arbitrary. To be developed later more efficiently. This should, instead, simply check a teacher custom questions branch which would speed up requests a lot. However, this is better if teachers want to set custom questions for each one of their classes.
        Utility.startLoading(view: self.view)
        
        dispatchGroup.notify(queue: .main, execute: {
            QuestionService.getCustomQuestions(forCourse: self.coursesTaught[0], completion: {(fields) in
                Utility.endLoading()
                if fields != nil {
                    print("Custom questions set for today")
                } else {
                    print("No custom questions created for today")
                    let nextVC = UIStoryboard(name: "Login", bundle: .main).instantiateViewController(withIdentifier: "questionCreationController") as! QuestionCreationViewController
                    nextVC.isDefaultQuestionController = false
                    self.present(nextVC, animated: true, completion: nil)
                }
                
            })
            
        
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
        return coursesTaught.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCourse = coursesTaught[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherInterfaceCell", for: indexPath) as! TeacherInterfaceTableViewCell
        cell.classNameLabel.text = currentCourse.title
        
        
        ReviewService.showReviewIDs(forCourseID: currentCourse.courseID, forSchoolID: currentCourse.schoolID, completion: {(reviewIDs) in
            guard let reviewIDs = reviewIDs else  {
                print("Error when trying to obtain current number of course reviews for today when populating the cells")
                return
            }
            cell.studentsCompletedPollLabel.text = String(reviewIDs.count)
            
        })
        
        cell.totalStudentsLabel.text = String(coursesTaught[indexPath.row].studentIDs.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFeedbackController", sender: self)
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFeedbackController" {
            let vc = segue.destination as! CourseFeedbackController
            vc.currentCourse = coursesTaught[tableView.indexPathsForSelectedRows![0].row]
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
