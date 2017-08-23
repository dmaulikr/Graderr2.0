//
//  ReviewService.swift
//  Graderr
//
//  Created by Sean Strong on 8/22/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

struct ReviewService {
    
    
    //also needs to take in the orgID from the current user, who should be a student
    static func getPollForToday(forCourseID courseID : String) -> [Field] {
        return []
    }
    
    
    //also needs to take in the orgID from the current user, who should be a teacher
    static func writePollForToday(forCourseID courseID : String, fields : [Field], success: @escaping (Bool) -> Void) {
        
    }
    
    static func submitReview(forCourseID courseID : String, studentID : String, answers : [Field], success : @escaping (Bool) -> Void) {
        
    }
    
    
    
    
    
    
}
