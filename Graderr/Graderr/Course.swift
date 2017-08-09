//
//  Course.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//


import Foundation

class Course {
    
    let title : String
    let teacher : Teacher
    let period : Int?
    let averageRating : Double?
    let students : [Student]
    
    init (title: String, teacher : Teacher, students : [Student], averageRating : Double?, period : Int?) {
        self.title = title
        self.teacher = teacher
        self.students = students
        self.averageRating = averageRating
        self.period = period
    }
    
    convenience init (title: String, teacher: Teacher, period: Int?) {
        self.init(title: title, teacher: teacher, students: [], averageRating: nil, period: period)
    }
    
}
