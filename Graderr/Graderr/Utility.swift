//
//  Question+Utility.swift
//  Graderr
//
//  Created by Sean Strong on 8/23/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

struct Utility {
    
    static let writeToUserDefaults = true
    
    static var activityIndicator = UIActivityIndicatorView()
    
    static func logOut(success: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            success(true)
        } catch {
            success(false)
        }
        
        
    }
    
    static func configureActivityIndicator (view: UIView) {
        Utility.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        Utility.activityIndicator.center = view.center
        Utility.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
    }
    
    static func startLoading(view: UIView) {
        configureActivityIndicator(view: view)
        Utility.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    static func endLoading() {
        Utility.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    //to be implemented
    static func dateToString(date : Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        return formatter.string(from: date)
        
    }
    
    static func stringToDate(dateString : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        return formatter.date(from: dateString)
    }
    
    static func newFirebaseKey() -> String {
        return Database.database().reference().childByAutoId().key
    }
    
    
    static func createAlert(title: String, message: String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { (action) in
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
    static func arrayOfTuplesIntoDictionary(array : [(String,String)]) -> [String:String] {
        var finalDict = [String:String]()
        for item in array {
            finalDict[item.0] = item.1
        }
        return finalDict
    }
    
    static let defaultGreen = UIColor.init(red: 59/255, green: 209/255, blue: 134/255, alpha: 1)
    
}
