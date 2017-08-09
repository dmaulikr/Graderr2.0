//
//  Teacher.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

class Teacher {
    
    let firstName : String
    let lastName : String
    let fullName : String
    let teacherID : String
    let courses : [Course]
    
    init (firstName: String, lastName : String, fullName: String, teacherID: String, courses: [Course]) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.teacherID = teacherID
        self.courses = courses
    }
    
    convenience init (firstName: String, lastName: String, teacherID: String) {
        self.init(firstName: firstName, lastName: lastName, fullName: firstName + " " + lastName, teacherID: teacherID, courses: [])
    }
    
    
    
    
    
    
    
    
    
    
    
}
