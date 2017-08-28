//
//  QuestionService.swift
//  Graderr
//
//  Created by Sean Strong on 8/23/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase

//Need to implement: 
//1. Need field parsing; both created a dict value for a field but also being able to parse through it


struct QuestionService {
    
    static func setCustomQuestions(forCourse course : Course, forDateString dateString: String = Utility.dateToString(), questionDict : [String: String], success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("questions").child(course.schoolID).child("courses").child(course.courseID).child("customQuestions").child(dateString)
        
        ref.setValue(questionDict) { (error,ref) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            success(true)
            
            
        }
        
    }
    
    static func setDefaultCourseQuestions(forCourse course : Course, questionDict : [String: String], success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("questions").child(course.schoolID).child("courses").child(course.courseID).child("defaultQuestions")
        
        ref.setValue(questionDict) { (error,ref) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            success(true)
            
            
        }
        
    }
    
    static func setDefaultSchoolQuestions(forSchoolID schoolID : String, questionDict : [String: String], success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("questions").child(schoolID).child("defaultQuestions")
        
        ref.setValue(questionDict) { (error,ref) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            success(true)
            
            
        }
    }
    
    static func getDefaultSchoolQuestions(forSchoolID schoolID : String, completion: @escaping ([Field]?) -> Void) {
        
        let ref = Database.database().reference().child("questions").child(schoolID).child("defaultQuestions")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let questionDict = snapshot.value as? [String: String] else {
                print("Unable to convert snapshot to questionDict for default school questions")
                return completion(nil)
            }
            completion(questionDict.map({ (key,value) in //can eventually abstract away this mapping code
                switch value {
                case Constants.QuestionTypes.bool:
                    return BoolField.init(title: key)
                case Constants.QuestionTypes.numeric:
                    return NumericField.init(title:key)
                case Constants.QuestionTypes.written:
                    return WrittenField.init(title: key)
                default:
                    fatalError("Wrong type of field acquired")
                }
            }))
            
            
        
        })
        
    }
    
    static func getDefaultCourseQuestions(forCourse course: Course, completion: @escaping ([Field]?) -> Void) {
        let ref = Database.database().reference().child("questions").child(course.schoolID).child("courses").child(course.courseID).child("defaultQuestions")
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let questionDict = snapshot.value as? [String: String] else {
                print("Unable to convert snapshot to questionDict for default course questions")
                return completion(nil)
            }
            completion(questionDict.map({ (key,value) in
                switch value {
                case Constants.QuestionTypes.bool:
                    return BoolField.init(title: key)
                case Constants.QuestionTypes.numeric:
                    return NumericField.init(title:key)
                case Constants.QuestionTypes.written:
                    return WrittenField.init(title: key)
                default:
                    fatalError("Wrong type of field acquired")
                }
            }))
            
        })
    }
    
    static func getCustomQuestions(forCourse course: Course, forDateString dateString: String = Utility.dateToString(), completion:  @escaping ([Field]?) -> Void) {
        
        let ref = Database.database().reference().child("questions").child(course.schoolID).child("courses").child(course.courseID).child("customQuestions").child(dateString)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let questionDict = snapshot.value as? [String: String] else {
                print("Unable to convert snapshot to questionDict for custom course questions")
                return completion(nil)
            }
            completion(questionDict.map({ (key,value) in
                switch value {
                case Constants.QuestionTypes.bool:
                    return BoolField.init(title: key)
                case Constants.QuestionTypes.numeric:
                    return NumericField.init(title:key)
                case Constants.QuestionTypes.written:
                    return WrittenField.init(title: key)
                default:
                    fatalError("Wrong type of field acquired")
                }
            }))
            
        })
    }
    
    //takes in a questionDict, that has the question as key and the type as a value
    //convienence init for today's questions
    static func getQuestions(forCourse course: Course, forDateString dateString: String = Utility.dateToString(), completion: @escaping ([Field]?) -> Void) {
        var todaysQuestions : [Field] = []
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        QuestionService.getDefaultSchoolQuestions(forSchoolID: course.schoolID, completion: {(fields) in
            guard let fields = fields else {
                return completion(nil)
            }
            print("1. Default school questions obtained successfully")
            todaysQuestions.append(contentsOf: fields)
            dispatchGroup.leave()
            
        })
        
        dispatchGroup.enter()
        QuestionService.getDefaultCourseQuestions(forCourse: course, completion: {(fields) in
            guard let fields = fields else {
                return completion(nil)
            }
            print("2. Default course questions obtained succesfully")
            todaysQuestions.append(contentsOf: fields)
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        QuestionService.getCustomQuestions(forCourse: course, forDateString: dateString, completion: {(fields) in
            guard let fields = fields else {
                return completion(nil)
            }
            print("3. Custom course questions obtained succesfully")
            todaysQuestions.append(contentsOf: fields)
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main, execute: {
            print("4. Dispatch group notify activated")
            completion(todaysQuestions)
        })
    }
 
    
}
