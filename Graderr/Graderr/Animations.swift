//
//  Animations.swift
//  Graderr
//
//  Created by Sean Strong on 9/2/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func rotate360Degrees(duration: CFTimeInterval = 2.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    

    

    
    
    
    
    
    
    
    
    
    
    
}
