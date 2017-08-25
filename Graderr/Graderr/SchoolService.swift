//
//  SchoolService.swift
//  Graderr
//
//  Created by Sean Strong on 8/16/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct SchoolService {
    
    static func createSchool(schoolName : String, adminUID : String, completion: @escaping (School?) -> Void) {
        let userAttrs = ["schoolName": schoolName, "adminUID" : adminUID]
        
        let ref = Database.database().reference().child("schools").childByAutoId()
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let school = School(snapshot: snapshot)
                completion(school)
            })
        }
    }
    
    
    static func show(forSchoolID schoolID: String, completion: @escaping (School?) -> Void) {
        let ref = Database.database().reference().child("schools").child(schoolID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let school = School(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(school)
        })
    }
    
    static func showCourseIDs(forSchoolID schoolID: String, completion: @escaping ([String]?) -> Void) {
        let ref = Database.database().reference().child("schools").child("courses")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let courseDict = snapshot.value as? [String : String] else {
                print("Error obtaining courseIDs for given school")
                return completion(nil)
            }
            completion(Array(courseDict.keys))
        })
    }
    
    
    
    static func showAllSchools(completion: @escaping ([School]?) -> Void) {
        let ref = Database.database().reference().child("schools")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotArray = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Unable to obtain snapshot values for schools. Double check the Firebase branching")
                return completion(nil)
            }
            
            completion(snapshotArray.map({ School(snapshot: $0)! })) //would crash here if the snapshot received was not valid; fix would be to go through the array item by item, converting into the school class
            
        })
    }
    
    
    
    
    
}

/*
 //this will give me issues, because I essentially need to obtain a list of course for a certain school id
 static func showCourses(forSchoolID schoolID: String, completion: @escaping ([Course]?) -> Void) {
 let ref = Database.database().reference().child("schools").child(schoolID).child("courses")
 ref.observeSingleEvent(of: .value, with: { (snapshot) in
 guard let courseDict = snapshot as? [String : String] else {
 return completion(nil)
 }
 var courseArray = [Course]()
 for courseID in courseDict.keys {
 CourseService.show(forCourseID: courseID, schoolID: schoolID, completion: {(course) in
 if let course = course {
 courseArray.append(course)
 }
 
 
 })
 }
 
 completion(courseArray)
 
 
 
 
 
 
 })
 
 
 }
 */
