//
//  Teacher.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Teacher : NSObject {
    
    
    private static var _current: Teacher?
    
    let name : String
    let teacherID : String
    let schoolID : String
    let courseIDs : [String]
    
    init (name: String, teacherID: String, schoolID : String, courseIDs : [String]) {
        self.name = name
        self.teacherID = teacherID
        self.schoolID = schoolID
        self.courseIDs = courseIDs
        super.init()
    }

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String,
            let schoolID = dict["schoolID"] as? String
            else { return nil }
        
        self.teacherID = snapshot.key
        self.name = name
        self.schoolID = schoolID
        
        if let courses = dict["courses"] as? [String: String] {
            courseIDs = Array(courses.keys)
        } else {
            courseIDs = []
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let schoolID = aDecoder.decodeObject(forKey: Constants.TeacherDefaults.schoolID) as? String,
            let teacherID = aDecoder.decodeObject(forKey: Constants.TeacherDefaults.teacherID) as? String,
            let name = aDecoder.decodeObject(forKey: Constants.TeacherDefaults.name) as? String,
            let courseIDs = aDecoder.decodeObject(forKey: Constants.TeacherDefaults.courseIDs) as? [String]
            else { return nil }
        
        self.schoolID = schoolID
        self.name = name
        self.teacherID = teacherID
        self.courseIDs = courseIDs
        
        super.init()
    }

    static func setCurrent(_ teacher: Teacher, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: teacher)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentTeacher)
        }
        
        _current = teacher
    }
    
    static var current: Teacher {
        // 3
        guard let currentTeacher = _current else {
            fatalError("Error: current teacher doesn't exist")
        }
        
        // 4
        return currentTeacher
    }
    
}

extension Teacher: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.TeacherDefaults.name)
        aCoder.encode(schoolID, forKey: Constants.TeacherDefaults.schoolID)
        aCoder.encode(teacherID, forKey: Constants.TeacherDefaults.teacherID)
        aCoder.encode(courseIDs, forKey: Constants.TeacherDefaults.courseIDs)
    }
}
