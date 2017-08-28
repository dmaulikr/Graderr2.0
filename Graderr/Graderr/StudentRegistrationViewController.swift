//
//  StudentRegistrationViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/15/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class StudentRegistrationViewController: UIViewController {
    
    //MARK - IBOutlets
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var schoolTableView: UITableView!
    
    @IBOutlet weak var coursesTableView: UITableView!
    
    //MARK - Properties
    var courses = [Course]() {
        didSet {
            coursesTableView.reloadData()
        }
    }
    
    
    var selectedCourses = [Course]() {
        didSet {
            coursesTableView.reloadData()
        }
    }
    
    
    var schools = [School]() {
        didSet {
            schoolTableView.reloadData()
        }
    }
    
    
    var selectedSchool : School? {
        didSet {
            CourseService.showAllCourses(forSchoolID: selectedSchool!.schoolID, completion: {(courses) in
                self.courses = courses ?? []
            })

        }
    }
    //MARK - IBActions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        StudentService.createStudent(Auth.auth().currentUser!, name: nameTextField.text!, schoolID: selectedSchool!.schoolID, completion: {(student) in
            guard let student = student else {
                print("StudentService.createStudent returned nil for student.")
                return
            }
            Student.setCurrent(student, writeToUserDefaults: false)
            let dispatchGroup = DispatchGroup()
            
            
            for course in self.selectedCourses {
                dispatchGroup.enter()
                CourseService.registerForCourse(student: student, course: course, success: {(success) in
                    print(success! ? "Succesfully added course named \(course.title)" : "Unable to register student for course")
                    dispatchGroup.leave()
                    
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                let initialViewController = UIStoryboard(name: "StudentInterface", bundle: .main).instantiateInitialViewController()!
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            })
            
            
            
        })
        
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        signUpButton.layer.cornerRadius = 6
        super.viewDidLoad()
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
        SchoolService.showAllSchools(completion: { (schools) in
            if let schools = schools {
                self.schools = schools
            } else {
                print("Unable to succesfully obtain schools")
            }
        })
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension StudentRegistrationViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: //school table view case
            return schools.count
        case 1: //courses table view case
            return courses.count
        default:
            print("Tag for tableview out of bounds")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0: //school table view case
            selectedSchool = schools[indexPath.row]
        case 1: //courses table view case
            if selectedCourses.contains(where: {$0.courseID == courses[indexPath.row].courseID}) {
                selectedCourses.remove(at: selectedCourses.index(where: {$0.courseID == courses[indexPath.row].courseID})!)
                //self.tableView(tableView, cellForRowAt: indexPath).backgroundColor = UIColor.gray
                print("Removed \(courses[indexPath.row]) from selectedCourses.")
            } else {
                selectedCourses.append(courses[indexPath.row])
                //self.tableView(tableView, cellForRowAt: indexPath).backgroundColor = UIColor.green
                print("Added \(courses[indexPath.row]) to selectedCourses.")
            }

        default:
            print("Tag for tableview out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch tableView.tag {
        case 0: //school table view case

            cell.textLabel?.text = schools[indexPath.row].schoolName
        case 1: //courses table view case

            cell.textLabel?.text = courses[indexPath.row].title
        default:
            print("Tag for tableview out of bounds")
        }
        return cell
    }
    
    
    
}
