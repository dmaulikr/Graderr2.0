//
//  LoginViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/9/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    
    var selectedController : Int = -1
    // MARK: - Properties
    
    @IBOutlet weak var studentLoginButton: UIButton!
    
    @IBOutlet weak var teacherLoginButton: UIButton!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        studentLoginButton.layer.cornerRadius = 6
        teacherLoginButton.layer.cornerRadius = 6
        
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        selectedController = sender.tag
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        // configure Auth UI for Facebook login
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(),FUIFacebookAuth()]
        authUI.providers = providers
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
        }
        
        // 1
        guard let user = user
            else { return }
        
        // 2
        
        switch selectedController {
        case 0 : print("Student login case")
        StudentService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                Student.setCurrent(user, writeToUserDefaults: Utility.writeToUserDefaults)
                
                let initialViewController = UIStoryboard(name: "StudentInterface", bundle: .main).instantiateInitialViewController()
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                self.performSegue(withIdentifier: Constants.Segue.toStudentLoginInterface, sender: self)
            }
            
            }
        case 1 : print("Teacher login case")
        TeacherService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                Teacher.setCurrent(user, writeToUserDefaults: Utility.writeToUserDefaults)
                
                let initialViewController = UIStoryboard(name: "TeacherInterface", bundle: .main).instantiateInitialViewController()
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                self.performSegue(withIdentifier: Constants.Segue.toTeacherLoginInterface, sender: self)
            }
            }
        default: print("Error; selected index not set yet.")
        }
        
        
    }
}
