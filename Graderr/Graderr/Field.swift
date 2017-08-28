//
//  Field.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation

class Field {
    enum FieldType {
        case bool
        case numeric
        case written
        
    }
    
    var value : Any?
    var fieldType : FieldType?
    let title : String
    
    init (title : String) {
        self.title = title
    }
    
    var dictValue : [String:Any] {
        if let value = value {
            return [title : value]
        } else {
            fatalError("The value for this field is nil. DictValue in class field.")
        }
    }
    
}

class BoolField : Field {
    
    
    init (title: String, value : Bool? = nil) {
        
        
        super.init(title: title)
        self.value = value
        self.fieldType = .bool
    }
}

class NumericField : Field {
    
    init (title: String, value: Int? = nil) {
        super.init(title: title)
        self.value = value
        self.fieldType = .numeric
        
    }
    
}

class WrittenField : Field {
    
    init (title: String, value: String? = nil) {
        super.init(title: title)
        self.fieldType = .written
        self.value = value
    }
    
}
