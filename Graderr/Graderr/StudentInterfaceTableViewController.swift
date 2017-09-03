//
//  StudentInterfaceTableViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/22/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class StudentInterfaceTableViewController: UITableViewController {
    
    var registeredCourses = [Course]()
    
    var reviewedCoursesIDs = [String]()
    
    @IBAction func logout(_ sender: Any) {
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
    override func viewDidAppear(_ animated: Bool) {
        
        StudentService.showCoursesIDsReviewedToday(forStudentID: Student.current.studentID, completion: {(courseIDs) in
            self.reviewedCoursesIDs = courseIDs ?? []
            self.tableView.reloadData()

        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.startLoading(view: self.view)
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        StudentService.showEnrolledCourses(student: Student.current, completion: {(courses) in
            self.registeredCourses = courses ?? []
            dispatchGroup.leave()
            
        })
        
        dispatchGroup.enter()
        StudentService.showCoursesIDsReviewedToday(forStudentID: Student.current.studentID, completion: {(courseIDs) in
            self.reviewedCoursesIDs = courseIDs ?? []
            dispatchGroup.leave()
            
        })
        
        dispatchGroup.notify(queue: .main, execute: {
            self.tableView.reloadData()
            Utility.endLoading()
            
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
        return registeredCourses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInterfaceCell", for: indexPath) as! StudentTableViewCell
        let currentCourse = registeredCourses[indexPath.row]
        cell.classNameLabel.text = currentCourse.title
        TeacherService.show(forUID: currentCourse.teacherID, completion: {(teacher) in
            
            cell.teacherNameLabel.text = teacher?.name
        })
        
        if reviewedCoursesIDs.contains(currentCourse.courseID) {
            cell.checkmarkImageView?.image = UIImage(named: "LogoInverted")
        } else {
            cell.checkmarkImageView?.image = UIImage(named: "EmptyGreenCircle")
        }
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !reviewedCoursesIDs.contains(registeredCourses[indexPath.row].courseID) {
            
            
            
            
            performSegue(withIdentifier: "toPoll", sender: self)
        } else {
            Utility.createAlert(title: "Already Submitted", message: "You have already submitted a review for today.", sender: self)
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPoll" {
            let vc = segue.destination as! PollSubmissionTableViewController
            vc.currentCourse = registeredCourses[tableView.indexPathsForSelectedRows![0].row]
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
