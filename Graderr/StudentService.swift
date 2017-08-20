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
        
    static func createStudent(_ firUser: FIRUser, username: String, completion: @escaping (Student?) -> Void) {
        let userAttrs = ["username": username]
        
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
    
    
    static func showEnrolledCourses(student: Student, completion: @escaping ([Course]?) -> Void) {
        let ref = Database.database().reference().child("students").child(student.studentID).child("courses")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String : String] else {
                print("Unable to obtain snapshot values for courses.")
                return completion(nil)
            }
            var courseList = [Course]()
            for courseID in Array(dict.keys) {
                CourseService.show(forCourseID: courseID, schoolID: student.schoolID, completion: {(course) in
                    if let course = course {
                        courseList.append(course)
                    }
                    
                    
                })
            }
            completion(courseList)
            
            
            
        })
        
    }
    
    
}


