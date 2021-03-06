//
//  TeacherRegistrationViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/15/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import FirebaseAuth
class TeacherRegistrationViewController: UIViewController {
    
    
    //MARK: - Properties
    var selectedSchool : School?  {
        didSet {
            //change background color of the uibutton from outlined green to total green :) 
            //signUpButton.backgroundColor = UIColor
        }
    }
    
    var schools = [School]() {
        didSet {
            schoolNameTableView.reloadData()
        }
    }
    
    
    var courseTitles = [String]() {
        didSet {
            classTableView.reloadData()
        }
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var schoolNameTableView: UITableView!
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var addClassTextField: UITextField!
    
    //MARK: - Views
    
    @IBOutlet weak var overallStackView: UIStackView!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var schoolStackView: UIStackView!
    @IBOutlet weak var classesTaughtStackView: UIStackView!
    //MARK: - IBActions
    
    @IBAction func addClass(_ sender: Any) {
        if addClassTextField.text! != "" {
            courseTitles.append(addClassTextField.text!)
            addClassTextField.text = ""
        } else {
            Utility.createAlert(title: "Error", message: "Please enter course title", sender: self)
        }

    }
    
    @IBAction func signUp(_ sender: Any) {
        //Utility.startLoading(view: self.view)
        TeacherService.createTeacher(Auth.auth().currentUser!, fullname: nameTextField.text!, schoolID: selectedSchool!.schoolID) { (teacher) in
            //Utility.endLoading()
            guard let teacher = teacher else {
                return
            }
            self.classesTaughtStackView.alpha = 1
            self.nameStackView.alpha = 0
            self.schoolStackView.alpha = 0
            self.signUpButton.alpha = 0
            let difference = self.schoolStackView.frame.minY - self.classesTaughtStackView.frame.minY
            let translation = CGAffineTransform(translationX: 0, y: difference)
            UIView.animate(withDuration: 0.5, animations: {
                self.overallStackView.transform = translation
            })
            self.doneButton.alpha = 1
            Teacher.setCurrent(teacher, writeToUserDefaults: Utility.writeToUserDefaults)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let dispatchGroup = DispatchGroup()
        //Utility.startLoading(view: self.view)
        
        for title in courseTitles {
            dispatchGroup.enter()
            CourseService.createCourse(teacherID: Teacher.current.teacherID, courseTitle: title, schoolID: selectedSchool!.schoolID, completion: {(course) in
                dispatchGroup.leave()
                if course != nil {
                    print("Succesfully saved course named \(course!.title)")
                } else {
                    Utility.createAlert(title: "Error", message: "Unable to create course succesfully.Please try again later.", sender: self)
                }
                
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            //Utility.endLoading()
            self.addClassTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.performSegue(withIdentifier: "toCreateQuestions", sender: self)
            //maybe I need to dismiss self here??
        })
        
        
        
        
        
        
        
       
        
    }
   

    
    

    
    
    override func viewDidLoad() {
        self.classTableView.allowsMultipleSelectionDuringEditing = false
        nameTextField.delegate = self
        addClassTextField.delegate = self
        classesTaughtStackView.alpha = 0
        doneButton.alpha = 0
        super.viewDidLoad()
        //tableview setup
        classTableView.delegate = self
        classTableView.dataSource = self
        schoolNameTableView.delegate = self
        schoolNameTableView.dataSource = self
        //view code
        
        
        //        classesTaughtStackView.isHidden = true
        //        signUpButton.isHidden = true

        signUpButton.layer.cornerRadius = 6
        doneButton.layer.cornerRadius = 6
        
        SchoolService.showAllSchools(completion: { (schools) in
            if let schools = schools {
                self.schools = schools
            } else {
                print("Unable to succesfully obtain schools")
            }
        })

        // Do any additional setup after loading the view.
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

extension TeacherRegistrationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0: //school table view case
            selectedSchool = schools[indexPath.row]
            schoolNameTableView.reloadData()
        case 1: //courses table view case
            print("Selected table view cell in the courses taught tableview.")
        default:
            print("Tag for tableview out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: //school search case
            return schools.count
        case 1: //classes added case
            return courseTitles.count
        default:
            fatalError("Table view identifier error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        switch tableView.tag {
        case 0: //school search case
            if selectedSchool?.schoolID == schools[indexPath.row].schoolID {
                cell.backgroundColor = Utility.defaultGreen
            }
            cell.textLabel?.text = schools[indexPath.row].schoolName
        case 1: //classes added case
            cell.textLabel?.text = courseTitles[indexPath.row]
        default:
            fatalError("Table view identifier error")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 0 {
            return false
        } else {
            return true
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 2
        if editingStyle == .delete {
            ///CourseService.
            courseTitles.remove(at: indexPath.row)
            // 3
            
        }
    }
}

extension TeacherRegistrationViewController : UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}




