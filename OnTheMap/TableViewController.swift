//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/26/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //Variables/Constants
    
    let reusableCell = "cell"
    var TableData:Array< Any > = Array < Any >()
    var parseAPI = ParseAPI()

    //Lifecycle methods
    
    func doTableRefresh(callback: (Result) -> Void) {
            tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseAPI.getMapData(callback: { (result) -> Void in
            if result == Result.OK {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell:TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: reusableCell) as! TableViewCell
        cell.myImageCell.image = UIImage(named: "pinLocation")
        let studentInformation = StudentLocationModel.student[indexPath.row]
        //Name of the student
        cell.myCellLabel.text = "\(studentInformation.firstNameKey) \(studentInformation.lastNameKey)"
        // Media Link for the Student
        cell.mediaLinkCell.text = "\(studentInformation.mediaURLKey)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        // if the url is properly written -> open Safari at link
        let studentInfo = StudentLocationModel.student[indexPath.row]
        let url = NSURL(string: studentInfo.mediaURLKey)
        if UIApplication.shared.canOpenURL(url as! URL) == true {
            UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
        }
    }
}

