//
//  TeacherService.swift
//  Graderr
//
//  Created by Sean Strong on 8/14/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//


import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct TeacherService {
    
    
    static func createTeacher(_ firUser: FIRUser, fullname : String, schoolID : String, completion: @escaping (Teacher?) -> Void) {
        let userAttrs = ["name": fullname, "schoolID" : schoolID]
        
        let ref = Database.database().reference().child("teachers").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let teacher = Teacher(snapshot: snapshot)
                completion(teacher)
            })
        }
        
        
    }
    
    static func show(forUID uid: String, completion: @escaping (Teacher?) -> Void) {
        let ref = Database.database().reference().child("teachers").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let teacher = Teacher(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(teacher)
        })
    }
    
    static func showCourseIDs(forTeacherID teacherID : String, completion : @escaping ([String]?) -> Void ) {
        
        let ref = Database.database().reference().child("teachers").child(teacherID).child("courses")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String : String] else {
                print("Unable to obtain snapshot values for courses.")
                return completion(nil)
            }
            
            completion(Array(dict.keys))
        })
    }
    
    static func showCoursesTeaching(forTeacher teacher: Teacher, completion: @escaping ([Course]?) -> Void) {
        
        TeacherService.showCourseIDs(forTeacherID: teacher.teacherID, completion: {(courseIDs) in
            guard let courseIDs = courseIDs else {
                print("showCourseIDs returned nil in the completion")
                return completion(nil)
            }
            
            let dispatchGroup = DispatchGroup()
            var courseList = [Course]()
            
            for courseID in courseIDs {
                dispatchGroup.enter()
                CourseService.show(forCourseID: courseID, schoolID: teacher.schoolID, completion: {(course) in
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

