//
//  CourseFeedbackController.swift
//  Graderr
//
//  Created by Sean Strong on 8/31/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class CourseFeedbackController: UIViewController {
    
    @IBOutlet weak var overallTableView: UITableView!
    @IBOutlet weak var todayTableView: UITableView!
    
    var todaysMetrics = [Field]()
    
    var overallMetrics = [Field]()
    
    var currentCourse : Course?
    
    var isOverall : Bool?
    
    var selectedField : Field?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overallTableView.isHidden = false
        overallTableView.isOpaque = true
        overallTableView.delegate = self
        overallTableView.dataSource = self
        todayTableView.delegate = self
        todayTableView.dataSource = self
        self.navigationItem.title = currentCourse?.title

        

        
        QuestionService.getCustomQuestions(forCourse: currentCourse!, completion: {(fields) in
            guard let fields = fields else {
                fatalError("Error obtaining custom questions for this course")
            }
            self.todaysMetrics = fields
            self.todayTableView.reloadData()
        })
        
        QuestionService.getDefaultCourseQuestions(forCourse: currentCourse!, completion:{ (fields) in
            guard let fields = fields else {
                fatalError("Error obtaining custom questions for this course")
            }
            self.overallMetrics = fields
            self.overallTableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.

        if segue.identifier == "toPie" {
            let vc = segue.destination as! PieChartViewController
            vc.currentCourse = currentCourse
            vc.desiredField = selectedField
        } else if segue.identifier == "toWritten"{
            let vc = segue.destination as! WrittenFeedbackController
            vc.currentCourse = currentCourse
            vc.desiredField = selectedField
            vc.isOverall = isOverall!
        } else if segue.identifier == "toLine" {
            let vc = segue.destination as! OverallAnalyticsController
            vc.currentCourse = currentCourse
            vc.desiredField = selectedField
        }
     }
    
    
}

extension CourseFeedbackController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: //today case
            return todaysMetrics.count
        case 1: //overall case
            return overallMetrics.count
        default:
            fatalError("Incorrect table view tag")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case 0: //today case
            let cell = todayTableView.dequeueReusableCell(withIdentifier: "questionCreationCell", for: indexPath) as! QuestionCreationCell
            let fieldOfInterest = todaysMetrics[indexPath.row]
            cell.questionContentLabel.text = fieldOfInterest.title
            switch fieldOfInterest.fieldType! {
            case .bool:
                cell.questionTypeImageView.image = UIImage(named: "YesNoIcon")
            case .written:
                cell.questionTypeImageView.image = UIImage(named: "WrittenIcon")
            case .numeric:
                cell.questionTypeImageView.image = UIImage(named: "NumericIcon")
            }
            return cell
        case 1: //overall case
            let cell = overallTableView.dequeueReusableCell(withIdentifier: "questionCreationCell", for: indexPath) as! QuestionCreationCell
            let fieldOfInterest = overallMetrics[indexPath.row]
            cell.questionContentLabel.text = fieldOfInterest.title
            switch fieldOfInterest.fieldType! {
            case .bool:
                cell.questionTypeImageView.image = UIImage(named: "YesNoIcon")
            case .written:
                cell.questionTypeImageView.image = UIImage(named: "WrittenIcon")
            case .numeric:
                cell.questionTypeImageView.image = UIImage(named: "NumericIcon")
                
            }
            return cell
        default:
            fatalError("Incorrect table view tag")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0: //today
            self.isOverall = false
            let fieldOfInterest = todaysMetrics[indexPath.row]
            switch fieldOfInterest.fieldType! {
            case .bool:
                print("\(fieldOfInterest.title), of type bool")
                selectedField = fieldOfInterest
                performSegue(withIdentifier: "toPie", sender: self)
            case .written:
                print("\(fieldOfInterest.title), of type written")
                selectedField = fieldOfInterest
                performSegue(withIdentifier: "toWritten", sender: self)
            case .numeric:
                print("\(fieldOfInterest.title), of type numeric")
                selectedField = fieldOfInterest
                performSegue(withIdentifier: "toPie", sender: self)
            }
            
        case 1: //overall
            self.isOverall = true
            let fieldOfInterest = overallMetrics[indexPath.row]
            switch fieldOfInterest.fieldType! {
            case .bool:
                print("\(fieldOfInterest.title), of type bool")
                selectedField = fieldOfInterest
                performSegue(withIdentifier: "toLine", sender: self)
            case .written:
                print("\(fieldOfInterest.title), of type written")
                selectedField = fieldOfInterest
                performSegue(withIdentifier: "toWritten", sender: self)
            case .numeric:
                print("\(fieldOfInterest.title), of type numeric")
                selectedField = fieldOfInterest
                performSegue(withIdentifier: "toLine", sender: self)
                
            }
            
        default:
            fatalError("Error obtaining tag from tableview")
        }
    }
    
    
    
}
