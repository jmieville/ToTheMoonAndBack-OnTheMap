//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/29/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    //Outlets
    
    @IBOutlet weak var logOutBtn: UIBarButtonItem!
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    
    //Actions
    
    @IBAction func doLogOut(_ sender: Any) {
        logOut()
    }
    @IBAction func doPost(_ sender: Any) {
    }

    //Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title on the navigationBar
        navigationItem.title = "OnTheMap"
        
        // showMapView
        
        let queueUserMapInfo = DispatchQueue.main
        queueUserMapInfo.async(execute: {
            // get user info from Udacity API
            UdacityAPI.getUserInfo { (data, response, error) in
                if error != nil {
                    print("error in getting user info with Udacity API")
                }
            }
        })
    }
    
    //Private methods
    func logOut() {
        print("You just logged out")
        UdacityAPI.logOut(callback: { (result) -> Void in
            if result == Result.OK {
                DispatchQueue.main.async {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                self.presentAlert(title: "Could not log out", message: Messages.networkError, actionTitle: "Return")
            }
        })
    }
}
