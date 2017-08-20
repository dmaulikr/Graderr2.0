//
//  TeacherRegistrationViewController.swift
//  Graderr
//
//  Created by Sean Strong on 8/15/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import UIKit

class TeacherRegistrationViewController: UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var schoolNameTableView: UITableView!
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var addClassTextField: UITextField!
    
    //MARK: - IBActions
    
    @IBAction func addSchool(_ sender: Any) {
        //CourseService.addSchool(name:String)
        
    }
    
    @IBAction func addClass(_ sender: Any) {
        //CourseService.addClass(orgUID: String, teacherUID: String) { (class) in
        //   append to array
        //}
    }
    
    @IBAction func signUp(_ sender: Any) {
        //TeacherService.create(orgUID:String, teacherUID :String, 
    }
    
    
    
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TeacherRegistrationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: //school search case
            return 0
        case 1: //classes added case
            return 0
        default:
            fatalError("Table view identifier error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case 0: //school search case
            return UITableViewCell()
        case 1: //classes added case
            return UITableViewCell()
        default:
            fatalError("Table view identifier error")
        }

    }
    
}




