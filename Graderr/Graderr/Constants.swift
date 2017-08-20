//
//  Constants.swift
//  Graderr
//
//  Created by Sean Strong on 8/10/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

struct Constants {
    struct Segue {
        
        static let toCreateUsername = "toCreateUsername"
        static let toStudentLoginInterface = "toStudentLoginInterface"
        static let toTeacherLoginInterface = "toTeacherLoginInterface"
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let currentTeacher = "currentTeacher"
        static let currentStudent = "currentStudent"
        static let uid = "uid"
        static let username = "username"
    }
    
    struct StudentDefaults {
        
        static let studentID = "studentID"
        static let schoolID = "schoolID"
        static let name = "name"
        static let courseIDs = "courseIDs"
        
    }
    
    struct TeacherDefaults {
        static let teacherID = "teacherID"
        static let schoolID = "schoolID"
        static let name = "name"
        static let courseIDs = "courseIDs"
    }
}
