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
    

    
    
    
    //THIS WILL ALSO WRITE THE DEFAULT QUESTIONS TO THE DATABASE
    static func setCustomQuestions(forCourse course : Course, forDateString dateString: String = Utility.dateToString(), questionDict : [String: String], success: @escaping (Bool) -> Void) {
        

        let ref = Database.database().reference().child("questions").child(course.schoolID).child("courses").child(course.courseID).child("customQuestions").child(dateString)
        getDefaultQuestionsDict(forCourse: course, completion: {(dict) in
            guard let dict = dict else {
                fatalError("No default questions set for this course")
            }
            var finalDict = dict
            finalDict.update(other: questionDict)
            
            ref.setValue(finalDict) { (error,ref) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                success(true)
            }

        })
        

        
    }
    
    static func getDefaultQuestionsDict(forCourse course : Course, completion: @escaping ([String:String]?) -> Void) {
        let ref = Database.database().reference().child("teacherDefaultQuestions").child(course.teacherID)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let questionDict = snapshot.value as? [String: String] else {
                print("Unable to convert snapshot to questionDict for default school questions")
                return completion(nil)
            }
            completion(questionDict)
   
        })
  
    }

    
    
    
    static func setDefaultCourseQuestions(forCourse course : Course, questionDict : [String: String], success: @escaping (Bool) -> Void) {
        
        
        let data = ["questions/\(course.schoolID)/courses/\(course.courseID)/defaultQuestions" : questionDict, "teacherDefaultQuestions/\(course.teacherID)" : questionDict]
        Database.database().reference().updateChildValues(data) { (error,ref) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            success(true)
            
            
        }
    }
    
    static func setAllDefaultQuestions(forTeacher teacher : Teacher, questionDict : [String:String], success: @escaping (Bool) -> Void) {
        

        TeacherService.showCoursesTeaching(forTeacher: Teacher.current, completion: { (courses) in
            guard let courses = courses else {
                print("This teacher does not have any courses that they are teaching")
                return success(false)
            }
            let dispatchGroup = DispatchGroup()
            
            for course in courses {
                dispatchGroup.enter()
                QuestionService.setDefaultCourseQuestions(forCourse: course, questionDict: questionDict, success: {(currentSuccess) in
                    print(currentSuccess ? "Able to succesfully upload default course questions for \(course.title)" : "Error uploading default course questions for \(course.title)")
                    if !currentSuccess { success(false) }
                    dispatchGroup.leave()
                    
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                success(true)
            })
            
        })
    }
    
    //NEW VERSION; makes sure to also include the data from the defaults
    static func setAllCustomQuestions(forTeacher teacher : Teacher, questionDict : [String:String], success: @escaping (Bool) -> Void) {
        
        TeacherService.showCoursesTeaching(forTeacher: Teacher.current, completion: { (courses) in
            guard let courses = courses else {
                print("This teacher does not have any courses that they are teaching")
                return success(false)
            }
            let dispatchGroup = DispatchGroup()
            
            for course in courses {
                dispatchGroup.enter()
                QuestionService.setCustomQuestions(forCourse: course, questionDict: questionDict, success: {(currentSuccess) in
                    print(currentSuccess ? "Able to succesfully upload default course questions for \(course.title)" : "Error uploading default course questions for \(course.title)")
                    if !currentSuccess { success(false) }
                    dispatchGroup.leave()
                    
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                success(true)
            })
            
        })
  
    }
    
    
    //OLD VERSION: Only kept track of custom questions uploaded by teachers on the day of. The newer implementation means that instead, when teachers write to custom questions it includes all of the default questions as well. That way, when a student logs on they can't actually fill out data UNLESS there are custom questions set for the day.
//    static func setAllCustomQuestions(forTeacher teacher : Teacher, questionDict : [String:String], success: @escaping (Bool) -> Void) {
//        
//        TeacherService.showCoursesTeaching(forTeacher: Teacher.current, completion: { (courses) in
//            guard let courses = courses else {
//                print("This teacher does not have any courses that they are teaching")
//                return success(false)
//            }
//            let dispatchGroup = DispatchGroup()
//            
//            for course in courses {
//                dispatchGroup.enter()
//                QuestionService.setCustomQuestions(forCourse: course, questionDict: questionDict, success: {(currentSuccess) in
//                    print(currentSuccess ? "Able to succesfully upload default course questions for \(course.title)" : "Error uploading default course questions for \(course.title)")
//                    if !currentSuccess { success(false) }
//                    dispatchGroup.leave()
//                    
//                })
//            }
//            
//            dispatchGroup.notify(queue: .main, execute: {
//                success(true)
//            })
//            
//        })
//        
//    }
    
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
            if let fields = fields {
                print("Default school questions obtained successfully")
                todaysQuestions.append(contentsOf: fields)
            } else {
                print("No default school questions specified")
            }

            dispatchGroup.leave()
            
        })
        
        dispatchGroup.enter()
        QuestionService.getDefaultCourseQuestions(forCourse: course, completion: {(fields) in
            if let fields = fields {
                print("Default course questions obtained successfully")
                todaysQuestions.append(contentsOf: fields)
            } else {
                print("No default course questions specified")
            }
            
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        QuestionService.getCustomQuestions(forCourse: course, forDateString: dateString, completion: {(fields) in
            if let fields = fields {
                print("Custom course questions obtained successfully")
                todaysQuestions.append(contentsOf: fields)
            } else {
                print("No custom course questions specified")
            }
            
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main, execute: {
            print("4. Dispatch group notify activated")
            completion(todaysQuestions)
        })
    }
 
    
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
