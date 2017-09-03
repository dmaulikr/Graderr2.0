//
//  ChartViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/31/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {
    
    
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var currentCourse : Course?
    var filteredFields = [Field]()
    var answers = [Any]()
    var desiredField : Field?
    var isOverall : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionNameLabel.text = desiredField!.title
        
//        ReviewService.getReviews(forCourseID: currentCourse!.courseID, forSchoolID: currentCourse!.schoolID, completion: {(reviews) in
//            guard let reviews = reviews else {
//                return print("No reviews able to be retrieved, sadly :( ")
//            }
//            let doubleArrayOfFields = reviews.map({$0.fields})
//            for arrayOfFields in doubleArrayOfFields {
//                for field in arrayOfFields {
//                    if field.title == self.desiredField!.title {
//                        self.filteredFields.append(field)
//                    }
//                }
//            }
//
//            self.configurePieChart()
//            
//            
//            
//        })
        
        
        ReviewService.getAnswers(forCourse: currentCourse!, forQuestion: desiredField!.title, completion: {(answers) in
            guard let answers = answers else {
                return print("Issue getting answers for the given question.")
            }
            self.answers = Array(answers.values)
            self.configurePieChart()
        })

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func configurePieChart() {
        switch desiredField!.fieldType! {
        case .numeric:
            var values : [(label :String, value: Double)] = [(label: "One", value: 0),(label: "Two", value: 0),(label: "Three", value: 0),(label: "Four", value: 0),(label: "Five", value: 0)]
            for value in answers as! [Int] {
                switch value {
                case 1: values[0].value += 1
                case 2: values[1].value += 1
                case 3: values[2].value += 1
                case 4: values[3].value += 1
                case 5: values[4].value += 1
                default: fatalError("Out of bounds")
                }
            }
            
            
            ChartsUtility.createPieChart( values: values.filter({$0.value > 0}), pieChartView: pieChartView)
        case .bool:
            var values : [(label :String, value: Double)] = [(label: "Yes", value: 0),(label: "No", value: 0)]
            for value in answers as! [Bool] {
                switch value {
                case true: values[0].value += 1
                case false: values[1].value += 1
                }
            }
            
            ChartsUtility.createPieChart(values: values, pieChartView: pieChartView)
        case .written:
            fatalError("Should not have got here.")
        }
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
