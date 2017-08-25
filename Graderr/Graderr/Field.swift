//
//  Field.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

class Field {
    let title : String
    
    init (title : String) {
        self.title = title
    }
    
}

class BoolField : Field {
    let value : Bool?
    
    init (title: String, value : Bool? = nil) {
        self.value = value
        super.init(title: title)
    }
}

class NumericField : Field {
    let value : Int?
    
    init (title: String, value: Int? = nil) {
        self.value = value
        super.init(title: title)
        
    }

}

class WrittenField : Field {
    let value : String?
    
    init (title: String, value: String? = nil) {
        self.value = value
        super.init(title: title)
        
    }
    
}
