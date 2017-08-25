//
//  ReviewService.swift
//  Graderr
//
//  Created by Sean Strong on 8/22/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ReviewService {
    
    
    //also needs to take in the orgID from the current user, who should be a teacher
    static func submitReview(forCourse course : Course, forStudent student : Student, forDateString dateString : String = Utility.dateToString(), fields : [Field], success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("reviews").child(course.schoolID).child(course.courseID).child(dateString).child(student.studentID)
        
    }
    
    
    
    static func getReviews(forCourseID courseID : String, forSchoolID schoolID : String, forDateString dateString : String = Utility.dateToString(), completion : @escaping ([Review]?) -> Void) {
        
    }
    
    static func getAllTeacherReviews(forTeacherID teacher: String, forSchoolID schoolID: String, completion : @escaping (String,(String,[Review])) -> Void) {
        
    }
    
    static func getAllStudentReviews(forStudentID student: String, forSchoolID)
    
    //completes with a tuple representing the date of the reviews and the array of reviews being the student feedback
    // (dateAsString, [reviews for particular day])
    static func getAllCourseReviews(forCourseID courseID : String, forSchoolID schoolID : String, completion : @escaping (String,[Review]) -> Void) {
        
    }
    
    // (name of class, [(dateAsString, [reviews for particular day)]])
    static func getAllSchoolReviews(forSchoolID school : String, completion : @escaping (String,[(String,[Review])]) -> Void) {
        
    }
    
    
    
    
    
    
    
}
