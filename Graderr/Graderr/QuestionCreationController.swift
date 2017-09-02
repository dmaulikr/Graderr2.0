//
//  DefaultQuestionsViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/30/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class QuestionCreationViewController: UIViewController {
    
    //MARK: - Properties
    var questionsCreated = [(String,String)]() {
        didSet {
            questionsTableView.reloadData()
        }
    }
    
    var selectedQuestionType : String? //should eventually be an enum
    var isDefaultQuestionController : Bool = true
    
    
    // MARK: -IBOutlets
    @IBOutlet weak var promptLabel: UILabel!
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
            if isDefaultQuestionController {
                nextButtonImageView.image = UIImage(named:"NextButton")
            }
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
        if questionsCreated.count == 0 && isDefaultQuestionController {
            Utility.createAlert(title: "Error", message: "Please create at least one default question for your class", sender: self)
            
        } else if isDefaultQuestionController {
            
            Utility.startLoading(view: self.view)
            QuestionService.setAllDefaultQuestions(forTeacher: Teacher.current, questionDict: Utility.arrayOfTuplesIntoDictionary(array: self.questionsCreated), success: {(success) in
                
                Utility.endLoading()
                if success {
                    let nextVC = UIStoryboard(name: "Login", bundle: .main).instantiateViewController(withIdentifier: "questionCreationController") as! QuestionCreationViewController
                    nextVC.isDefaultQuestionController = false
                    self.present(nextVC, animated: true, completion: nil)
                } else {
                    Utility.createAlert(title: "Error", message: "Unable to submit reviews succesfully. Please try again later.", sender: self)
                }
            })
            
        } else {
            Utility.startLoading(view: self.view)
            QuestionService.setAllCustomQuestions(forTeacher: Teacher.current, questionDict: Utility.arrayOfTuplesIntoDictionary(array: self.questionsCreated), success: {(success) in
                Utility.endLoading()
                
                if success {
                    if (self.presentingViewController as? QuestionCreationViewController) != nil { //default question creation case
                        let homeVC = UIStoryboard(name: "TeacherInterface", bundle: .main).instantiateInitialViewController()
                        self.view.window?.rootViewController = homeVC
                        self.view.window?.makeKeyAndVisible()
                    } else { //daily case
                        self.dismiss(animated: true, completion: nil)
                    }

                    
                } else {
                    Utility.createAlert(title: "Error", message: "Unable to submit reviews succesfully. Please try again later.", sender: self)
                }
            
            
            
            
            
            })

        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        
        if isDefaultQuestionController {
            promptLabel.text = "What questions would you like to ask every day?"
            nextButtonImageView.image = UIImage(named:"NextButtonInverted")
        } else {
            promptLabel.text = "What questions would you like to ask today?"
            nextButtonImageView.image = UIImage(named:"LogoInverted")
        }
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

extension QuestionCreationViewController : UITableViewDelegate, UITableViewDataSource {
    
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



