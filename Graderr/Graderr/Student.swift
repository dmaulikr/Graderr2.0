//
//  Student.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Student : NSObject {
    
    
    //MARK: - Singleton
    private static var _current: Student?
    
    //MARK: - Properties
    let name : String
    let studentID : String
    let schoolID : String
    let courseIDs : [String]
    
    
    //MARK: - Intializers
    init (name: String, studentID: String, schoolID : String, courseIDs : [String] = []) {
        self.name = name
        self.studentID = studentID
        self.schoolID = schoolID
        self.courseIDs = courseIDs
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String,
            let schoolID = dict["schoolID"] as? String
            else { return nil }
        
        self.studentID = snapshot.key
        self.schoolID = schoolID
        self.name = name
        
        if let courses = dict["courses"] as? [String: String] {
            courseIDs = Array(courses.keys)
        } else {
            courseIDs = []
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let schoolID = aDecoder.decodeObject(forKey: Constants.StudentDefaults.schoolID) as? String,
            let studentID = aDecoder.decodeObject(forKey: Constants.StudentDefaults.studentID) as? String,
            let name = aDecoder.decodeObject(forKey: Constants.StudentDefaults.name) as? String,
            let courseIDs = aDecoder.decodeObject(forKey: Constants.StudentDefaults.courseIDs) as? [String]
            else { return nil }
        
        self.schoolID = schoolID
        self.name = name
        self.studentID = studentID
        self.courseIDs = courseIDs
        
        super.init()
    }
    
    
    static func setCurrent(_ student: Student, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: student)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentStudent)
        }
        
        _current = student
    }
    
    static var current: Student {
        // 3
        guard let currentStudent = _current else {
            fatalError("Error: current student doesn't exist")
        }
        
        // 4
        return currentStudent
    }
    
    
}

extension Student: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.StudentDefaults.name)
        aCoder.encode(schoolID, forKey: Constants.StudentDefaults.schoolID)
        aCoder.encode(studentID, forKey : Constants.StudentDefaults.studentID)
        aCoder.encode(courseIDs, forKey: Constants.StudentDefaults.courseIDs)
    }
}
