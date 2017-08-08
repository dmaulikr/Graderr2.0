//
//  Review.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

class Review {
    
    let student : Student
    let course : Course
    let fields : [Field]
    let date : Date
    
    init (student: Student, course : Course, date : Date, fields: [Field]) {
        self.student = student
        self.course = course
        self.date = date
        self.fields = fields
    }
    
    
    
    
    
}
