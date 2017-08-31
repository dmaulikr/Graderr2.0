//
//  DefaultQuestionsViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/30/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class DefaultQuestionsViewController: UIViewController {
    
    //MARK: - Properties
    var questionsCreated = [(String,String)]() {
        didSet {
            questionsTableView.reloadData()
        }
    }
    
    var selectedQuestionType : String? //should eventually be an enum
    
    
    // MARK: -IBOutlets
    @IBOutlet weak var questionContentTextField: UITextField!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var yesNoImageView: UIImageView!
    @IBOutlet weak var numericImageView: UIImageView!
    @IBOutlet weak var writtenImageView: UIImageView!
    @IBOutlet weak var nextButtonImageView: UIImageView!
    
    // MARK: -IBActions
    
    @IBAction func createQuestionButtonPressed(_ sender: Any) {
        if questionContentTextField.text == "" {
            Utility.createAlert(title: "Error", message: "Please fill out a question in the textfield", sender: self)
        } else if selectedQuestionType == nil {
            Utility.createAlert(title: "Error", message: "Please select an appropriate question type", sender: self)
        } else {
            nextButtonImageView.image = UIImage(named:"NextButton")
            questionsCreated.append((question :questionContentTextField.text!, type: selectedQuestionType!))
            questionContentTextField.text = ""
        }
        
    }
    
    
    @IBAction func selectionButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: //yes|no case
            selectedQuestionType = "bool"
            yesNoImageView.image = UIImage(named: "YesNoSelected")
            writtenImageView.image = UIImage(named: "WrittenUnselected")
            numericImageView.image = UIImage(named: "1to5Unselected")
        case 1: //numeric case
            selectedQuestionType = "numeric"
            yesNoImageView.image = UIImage(named: "YesNoUnselected")
            writtenImageView.image = UIImage(named: "WrittenUnselected")
            numericImageView.image = UIImage(named: "1to5Selected")
        case 2: //written question case
            selectedQuestionType = "written"
            yesNoImageView.image = UIImage(named: "YesNoUnselected")
            writtenImageView.image = UIImage(named: "WrittenSelected")
            numericImageView.image = UIImage(named: "1to5Unselected")
        default:
            fatalError("button tag out of bounds")
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if questionsCreated.count == 0 {
            Utility.createAlert(title: "Error", message: "Please create at least one default question for your class", sender: self)
        } else {
            
            Utility.startLoading(view: self.view)
            TeacherService.showCoursesTeaching(forTeacher: Teacher.current, completion: { (courses) in
                guard let courses = courses else {
                    fatalError("This teacher does not have any courses that they are teaching")
                }
                let dispatchGroup = DispatchGroup()
                
                for course in courses {
                    dispatchGroup.enter()
                    QuestionService.setDefaultCourseQuestions(forCourse: course, questionDict: Utility.arrayOfTuplesIntoDictionary(array: self.questionsCreated), success: {(success) in
                        print(success ? "Able to succesfully upload default course questions for \(course.title)" : "Error uploading default course questions for \(course.title)")
                        dispatchGroup.leave()
                        
                    })
                }
                
                dispatchGroup.notify(queue: .main, execute: {

                    Utility.endLoading()
                    Utility.createAlert(title: "Success", message: "Eventually implement a segue here", sender: self)
                })
                
            })
            
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
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

extension DefaultQuestionsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentQuestion = questionsCreated[indexPath.row]
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: "questionCreationCell", for: indexPath) as! QuestionCreationCell
        cell.questionContentLabel.text = currentQuestion.0
        switch currentQuestion.1 {
        case "bool":
            cell.questionTypeImageView.image = UIImage(named: "YesNoIcon")
        case "written":
            cell.questionTypeImageView.image = UIImage(named: "WrittenIcon")
        case "numeric":
            cell.questionTypeImageView.image = UIImage(named: "NumericIcon")
        default:
            fatalError("Unspecified current question type -> perhaps string issue?")
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsCreated.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}



