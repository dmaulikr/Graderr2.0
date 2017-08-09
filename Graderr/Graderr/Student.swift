//
//  Student.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

class Student {
    
    let firstName : String
    let lastName : String
    let fullName : String
    let studentID : String
    var courses : [Course]
    
    
        init (firstName: String, lastName : String, fullName: String, studentID: String, courses: [Course]) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.studentID = studentID
        self.courses = courses
    }
    
    convenience init (firstName: String, lastName: String, studentID: String) {
        self.init(firstName: firstName, lastName: lastName, fullName: firstName + " " + lastName, studentID: studentID, courses: [])
    }
    
    
}
