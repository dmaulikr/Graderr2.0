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
    

    
    static func showReview(forReviewID reviewID : String, completion: @escaping (Review?) -> Void) {
        let ref = Database.database().reference().child("reviewInfo").child(reviewID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let review = Review(snapshot: snapshot) else {
                fatalError("Unable to succesfully obtain review")
                //return nil
            }
            
            completion(review)
        })
    }
    
    
    static func submitReview(review : Review, forDateString dateString : String = Utility.dateToString(), success: @escaping (Bool) -> Void) {
        
        let data : [String: Any] = [
            "courseReviews/\(review.schoolID)/\(review.courseID)/\(dateString)/\(review.studentID)" : review.reviewID,
            "schoolReviews/\(review.schoolID)/\(dateString)/\(review.courseID)/\(review.reviewID))" : review.studentID,
            "studentReviews/\(review.studentID)/\(dateString)/\(review.courseID)" : review.reviewID,
            "reviewInfo/\(review.reviewID)" : review.dictValue,
            ]
        
        Database.database().reference().updateChildValues(data) { (error, _) in
            if let error = error { fatalError(error.localizedDescription) }
            success(true)
            
        }
        
    }
    
    
    static func showReviewIDs(forCourseID courseID : String, forSchoolID schoolID : String, forDateString dateString : String = Utility.dateToString(), completion : @escaping ([String]?) -> Void) {
        
        let ref = Database.database().reference().child("courseReviews").child(schoolID).child(courseID).child(dateString)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dictOfReviewIDs = snapshot.value as? [String:String] else {
                print("unable to cast the value to a dictionary of reviewIDs")
                return completion(nil)
            }
            
            completion(Array(dictOfReviewIDs.values))
        })
    }
    
    static func getReviews(forCourseID courseID : String, forSchoolID schoolID : String, forDateString dateString : String = Utility.dateToString(), completion : @escaping ([Review]?) -> Void) {

        ReviewService.showReviewIDs(forCourseID: courseID, forSchoolID: schoolID, forDateString: dateString, completion: {(reviewIDs) in
            guard let reviewIDs = reviewIDs else {
                print("showReviewIDs returned nil in the completion")
                return completion(nil)
            }
            
            var arrayOfReviews = [Review]()
            let dispatchGroup = DispatchGroup()
            
            for reviewID in reviewIDs {
                dispatchGroup.enter()
                ReviewService.showReview(forReviewID: reviewID, completion: { (review) in
                    guard let review = review else {
                        fatalError("Review for this ID is nil")
                    }
                    arrayOfReviews.append(review)
                    dispatchGroup.leave()
                    
                })
            }
            
            dispatchGroup.notify(queue: .main , execute: {
                completion(arrayOfReviews)
            })
        
        })
    }

    
    
    static func getTeacherReviews(forTeacherID teacherID: String, forSchoolID schoolID : String, forDateString dateString : String = Utility.dateToString(), completion: @escaping ([Review]?) -> Void ) {
        TeacherService.showCourseIDs(forTeacherID: teacherID, completion: { (courseIDs) in
            guard let courseIDs = courseIDs else { fatalError("The courseIDs returned were nil") }
            let dispatchGroup = DispatchGroup()
            var allReviews = [Review]()
            
            for courseID in courseIDs {
                dispatchGroup.enter()
                ReviewService.getReviews(forCourseID: courseID, forSchoolID: schoolID, forDateString: dateString, completion: {(courseReviews) in
                    guard let courseReviews = courseReviews else {
                        print("The course reviews completion returned nil")
                        return completion(nil)
                    }
                    allReviews.append(contentsOf: courseReviews)
                    dispatchGroup.leave()
                    
                })
                
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(allReviews)
                
            })
        })
    }
    
    static func getStudentReviews(forStudentID studentID: String, forSchoolID schoolID : String, forDateString dateString : String = Utility.dateToString(), completion: @escaping ([Review]?) -> Void ) {
        
        StudentService.showCourseIDs(forStudentID: studentID, completion: { (courseIDs) in
            guard let courseIDs = courseIDs else { fatalError("The courseIDs returned were nil") }
            let dispatchGroup = DispatchGroup()
            var allReviews = [Review]()
            
            for courseID in courseIDs {
                dispatchGroup.enter()
                ReviewService.getReviews(forCourseID: courseID, forSchoolID: schoolID, forDateString: dateString, completion: {(courseReviews) in
                    guard let courseReviews = courseReviews else {
                        print("The course reviews completion returned nil")
                        return completion(nil)
                    }
                    allReviews.append(contentsOf: courseReviews)
                    dispatchGroup.leave()
                    
                })
                
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(allReviews)
                
            })
        })
        
    }
    

    

    

    //TO BE IMPLEMENTED

    static func getAllTeacherReviews(forTeacherID teacher: String, forSchoolID schoolID: String, completion : @escaping (String,(String,[Review])) -> Void) {
        
    }
    
    static func getAllStudentReviews(forStudentID student: String, forSchoolID schoolID: String, completion : @escaping (String,[Review]) -> Void) {
        
    }
    
    
    static func getSchoolReviews(forStudentID studentID: String, forSchoolID schoolID : String, forDateString dateString : String = Utility.dateToString(), completion: @escaping ([Review]?) -> Void ) {
        
    }
    
    
    // (name of class, [(dateAsString, [reviews for particular day)]])
    static func getAllSchoolReviews(forSchoolID school : String, completion : @escaping (String,[(String,[Review])]) -> Void) {
        
    }
    
    //completes with a tuple representing the date of the reviews and the array of reviews being the student feedback
    // (dateAsString, [reviews for particular day])
    static func getAllCourseReviews(forCourseID courseID : String, forSchoolID schoolID : String, completion : @escaping (String,[Review]) -> Void) {
        
    }

    
}
