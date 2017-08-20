//
//  Course.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//


import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Course {
    
    let title : String
    let schoolID : String
    let courseID : String
    let teacherID : String
    let studentIDs : [String]
    
    init (title: String, teacherID : String, courseID : String, schoolID : String, studentIDs : [String] = []) {
        self.title = title
        self.courseID = courseID
        self.teacherID = teacherID
        self.studentIDs = studentIDs
        self.schoolID = schoolID
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let title = dict["title"] as? String,
            let teacherID = dict["teacherID"] as? String,
            let schoolID = dict["schoolID"] as? String
            else { return nil }
        self.title = title
        self.teacherID = teacherID
        self.schoolID = schoolID
        self.courseID = snapshot.key

        if let studentSnapshots = dict["students"] as? [String: String]{ //[UID: Name]
            self.studentIDs = Array(studentSnapshots.keys)
        } else {
            self.studentIDs = []
            print("This course has no students enrolled!")
        }
    }
    
    
}
