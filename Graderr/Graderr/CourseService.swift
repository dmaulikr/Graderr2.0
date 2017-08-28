//
//  CourseService.swift
//  Graderr
//
//  Created by Sean Strong on 8/16/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct CourseService {
    
    static func createCourse(teacherID : String, courseTitle : String, schoolID : String, completion: @escaping (Course?) -> Void) {
        let userAttrs = ["schoolID": schoolID, "title" : courseTitle, "teacherID" : teacherID]
        
        let courseID = Database.database().reference().childByAutoId().key
        
        let courseCreationData : [String : Any] = ["courses/\(schoolID)/\(courseID)" : userAttrs, "schools/\(schoolID)/courses/\(courseID)": courseTitle, "teachers/\(teacherID)/courses/\(courseID)" : courseTitle]
        
        let ref = Database.database().reference()
        ref.updateChildValues(courseCreationData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.child("courses").child(schoolID).child(courseID).observeSingleEvent(of: .value, with: { (snapshot) in
                let course = Course(snapshot: snapshot)
                completion(course)
            })
        }
    }
    
    static func registerForCourse(student: Student, course : Course, success: @escaping (Bool?) -> Void ) {
        let ref = Database.database().reference()
        
        let registrationData =
            ["courses/\(course.schoolID)/\(course.courseID)/students/\(student.studentID)" : student.name,
             "students/\(student.studentID)/courses/\(course.courseID)" : course.title]
        
        ref.updateChildValues(registrationData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print("Was succesful upload to server!")
                success(true)
            })
        }
    }
    

    
    static func removeFromCourse(studentID : String, courseID : String, schoolID : String) {
        
        let registrationData =
            ["courses/\(schoolID)/\(courseID)/students/\(studentID)" : NSNull(),
             "students/\(studentID)/courses/\(courseID)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(registrationData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print("Was succesful in removing user.")
            })
        }
    }
    
    static func show(forCourseID courseID: String, schoolID : String, completion: @escaping (Course?) -> Void) {
        let ref = Database.database().reference().child("courses").child(schoolID).child(courseID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let course = Course(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(course)
        })
    }
    
    static func showAllCourses(forSchoolID schoolID: String, completion: @escaping ([Course]?) -> Void) {
        let ref = Database.database().reference().child("courses").child(schoolID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotArray = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Unable to obtain snapshot values for schools. Double check the Firebase branching")
                return completion(nil)
            }
            
            completion(snapshotArray.map({ Course(snapshot: $0)! })) //would crash here if the snapshot received was not valid; fix would be to go through the array item by item, converting into the school class
            
        })
    }
    
    
    
    
    
}
