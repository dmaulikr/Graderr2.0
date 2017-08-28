//
//  Review.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import FirebaseDatabase
import Foundation

class Review {
    
    let studentID : String
    let courseID : String
    let schoolID : String
    let reviewID : String
    var fields : [Field]
    
    
    //for uploading to firebase, returns a nested dictionary specifying different categories
    var dictValue : [String:Any] {
        var reviewData : [String: [String:Any]] =
            ["numeric": [String:Int]() ,"bool": [String:Bool](), "written": [String:String]()]
        
        for field in fields {
            switch field.fieldType! {
            case .numeric:
                reviewData["numeric"]?[field.title] = field.value
            case .bool:
                reviewData["bool"]?[field.title] = field.value
            case .written:
                reviewData["written"]?[field.title] = field.value
            }
        }
        
        return [reviewID : ["reviewData": reviewData, "studentID" : studentID, "courseID" : courseID, "schoolID" : schoolID]]
    }
    
    init (reviewID: String = Utility.newFirebaseKey(), studentID : String, courseID: String, schoolID: String, fields: [Field]) {
        self.reviewID = reviewID
        self.fields = fields
        self.courseID = courseID
        self.studentID = studentID
        self.schoolID = schoolID
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let studentID = dict["studentID"] as? String,
            let courseID = dict["courseID"] as? String,
            let schoolID = dict["schoolID"] as? String,
            let questionDict = dict["reviewData"] as? [String:[String:Any]]
            else { return nil }
        
        self.studentID = studentID
        self.courseID = courseID
        self.schoolID = schoolID
        self.reviewID = snapshot.key
        self.fields = [Field]()
        
        //boolean questions
        if let boolDict = questionDict["bool"] as? [String:Bool] {
            
            self.fields.append(contentsOf: boolDict.map({BoolField.init(title: $0.key, value: $0.value)}))
            
        } else {
            print("No boolean fields in this review")
        }
        
        //written questions
        if let writtenDict = questionDict["written"] as? [String:String] {
            
            self.fields.append(contentsOf: writtenDict.map({WrittenField.init(title: $0.key, value: $0.value)}))
            
        } else {
            print("No written fields in this review")
        }
        
        //numeric questions
        if let numericDict = questionDict["numeric"] as? [String:Int] {
            
            self.fields.append(contentsOf: numericDict.map({NumericField.init(title: $0.key, value: $0.value)}))
            
        } else {
            print("No numeric fields in this review")
        }

    }
      
    
    
    
}
