//
//  StudentService.swift
//  Graderr
//
//  Created by Sean Strong on 8/14/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//


import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct StudentService {
    
    static func createStudent(_ firUser: FIRUser, name: String, schoolID: String, completion: @escaping (Student?) -> Void) {
        let userAttrs = ["name": name, "schoolID" : schoolID]
        
        let ref = Database.database().reference().child("students").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let student = Student(snapshot: snapshot)
                completion(student)
            })
        }
    }
    
    
    static func show(forUID uid: String, completion: @escaping (Student?) -> Void) {
        let ref = Database.database().reference().child("students").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let student = Student(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(student)
        })
    }
    
    
    static func showCourseIDs(forStudentID studentID : String, completion : @escaping ([String]?) -> Void ) {
        
        let ref = Database.database().reference().child("student").child(studentID).child("courses")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String : String] else {
                print("Unable to obtain snapshot values for courses.")
                return completion(nil)
            }
            
            completion(Array(dict.keys))
        })
    }
    
    
    
    static func showEnrolledCourses(student: Student, completion: @escaping ([Course]?) -> Void) {
        StudentService.showCourseIDs(forStudentID: student.studentID, completion: {(courseIDs) in
            
            guard let courseIDs = courseIDs else {
                print("showCourseIDs returned nil in the completion")
                return completion(nil)
            }
            
            let dispatchGroup = DispatchGroup()
            var courseList = [Course]()
            
            for courseID in courseIDs {
                dispatchGroup.enter()
                CourseService.show(forCourseID: courseID, schoolID: student.schoolID, completion: {(course) in
                    if let course = course {
                        courseList.append(course)
                    }
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(courseList)
            })

            
        })
        
    }
    
    
}


