//
//  School.swift
//  Graderr
//
//  Created by Sean Strong on 8/16/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class School {
    
    let schoolID : String
    let schoolName : String
    let courseIDs : [String]
    
    init (schoolID : String, schoolName: String, courseIDs : [String] = []) {
        self.schoolID = schoolID
        self.schoolName = schoolName
        self.courseIDs = courseIDs
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let schoolName = dict["schoolName"] as? String
            else { return nil }
        self.schoolName = schoolName
        self.schoolID = snapshot.key
        if let courseSnapshots = dict["courses"] as? [String: String]{ //[UID: Name]
            courseIDs = Array(courseSnapshots.keys)
        } else {
            self.courseIDs = []
            print("This school has no courses!")
        }
    }
    
}
