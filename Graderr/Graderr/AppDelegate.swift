//
//  AppDelegate.swift
//  Graderr
//
//  Created by Sean Strong on 8/8/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        FirebaseApp.configure()
        configureUI()
        
        configureInitialRootViewController(for: window)
        // Override point for customization after application launch.
        return true
    }
    
    
    func configureUI (){
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
//        UINavigationBar.appearance().backgroundColor = 
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().isTranluscent = false
//        UINavigationBar.appearance().alpha = 1
//        UINavigationBar.appearance().isOpaque = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Graderr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Firebase Login Stack
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
        // other URL handling goes here
        
        return false
    }
    

}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil, //teacher case
            let teacherData = defaults.object(forKey: Constants.UserDefaults.currentTeacher) as? Data,
            let teacher = NSKeyedUnarchiver.unarchiveObject(with: teacherData) as? Teacher {
            
            print("Succesful teacher login")
            Teacher.setCurrent(teacher)
            initialViewController = UIStoryboard(name: "TeacherInterface", bundle: .main).instantiateInitialViewController()!
            
        } else if Auth.auth().currentUser != nil, // student case
            let studentData = defaults.object(forKey: Constants.UserDefaults.currentStudent) as? Data,
            let student = NSKeyedUnarchiver.unarchiveObject(with: studentData) as? Student {
            
            print("Succesful student login")
            Student.setCurrent(student)
            
            initialViewController = UIStoryboard(name: "StudentInterface", bundle: .main).instantiateInitialViewController()!
        } else {
            initialViewController = UIStoryboard(name: "Login", bundle: .main).instantiateInitialViewController()!
        }
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

