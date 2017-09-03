//
//  OverallAnalyticsController.swift
//  Graderr
//
//  Created by Sean Strong on 9/3/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import Charts

class OverallAnalyticsController: UIViewController {
    
    
    
    //MARK: --IBOutlets
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var questionNameLabel: UILabel!
    
    //MARK: -- Properties
    var answersOverTime = [(date: Date, answers: [Any])]()
    var currentCourse : Course?
    var desiredField : Field?

    override func viewDidLoad() {
        super.viewDidLoad()
        questionNameLabel.text = desiredField!.title
        ReviewService.getAllAnswers(forCourse: currentCourse!, forQuestion: desiredField!.title, completion: {(values) in
            guard let values = values else {
                print("Unable to get all answers")
                return
            }

            //formatting the data in a way that is easy to access and look at over time
            self.answersOverTime = Array(values).map({(key,value) in
                return (date: Utility.stringToDate(dateString: key)!, answers: Array(value.values))
            }).sorted(by: {$0.0.date > $0.1.date})
            self.configureLineChart()
        
        })
        
        

        // Do any additional setup after loading the view.
    }
    
    func configureLineChart() {
        switch desiredField!.fieldType! {
        case .bool:
            let desiredArray : [(date: Date, answerSum: Double)] = answersOverTime.map({(date,answers) in
                
                guard let answers = answers as? [Bool] else {
                    fatalError("Unable to cast to array of booleans appropriately")
                }
                return (date: date, answerSum : Double(answers.map({$0 ? 1 : 0}).reduce(0, +))/Double((answers.count)))

            })
            
            ChartsUtility.createLineChart(answersOverTime: desiredArray, lineChartView: lineChartView)

        case .numeric:
            let desiredArray : [(date: Date, answerSum: Double)] = answersOverTime.map({(date,answers) in
                
                guard let answers = answers as? [Int] else {
                    fatalError("Unable to cast to array of booleans appropriately")
                }
                return (date: date, answerSum : Double(answers.reduce(0, +))/Double((answers.count)))
                
            })
            
            ChartsUtility.createLineChart(answersOverTime: desiredArray, lineChartView: lineChartView)
            
        case .written:
            fatalError()
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
