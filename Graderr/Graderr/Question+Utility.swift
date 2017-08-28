//
//  Question+Utility.swift
//  Graderr
//
//  Created by Sean Strong on 8/23/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Utility {
    
    //to be implemented
    static func dateToString(date : Date = Date()) -> String {
        return "today"
        
    }
    
    static func newFirebaseKey() -> String {
        return Database.database().reference().childByAutoId().key
    }
    
    
}
