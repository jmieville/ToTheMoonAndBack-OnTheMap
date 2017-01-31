//
//  Extension.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 1/1/2560 BE.
//  Copyright © 2560 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Extensions & Additional features
    
    // dismiss keyboard
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Showing waiting spinner
    func showSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        DispatchQueue.main.async(execute: {
            spinner.center = self.view.center
            spinner.color = UIColor.red
            spinner.bringSubview(toFront: self.view)
            self.view.addSubview(spinner)
            spinner.startAnimating()
            print("This is spinning")
        })
        return spinner
    }
    
    // Presenting Alert for usage in different situation
    
    func presentAlert(error: NSError) {
        presentAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK", actionHandler: nil)
    }
    
    func presentAlert(title: String, message: String, actionTitle: String, actionHandler: ((UIAlertAction) -> Void)?) {
        let alertControllerStyle = UIAlertControllerStyle.alert
        let alertView = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        let alertActionStyle = UIAlertActionStyle.default
        let alertAction = UIAlertAction(title: actionTitle, style: alertActionStyle, handler: actionHandler)
        alertView.addAction(alertAction)
        DispatchQueue.main.async(execute: {
            self.present(alertView, animated: true, completion: nil)
        })
    }
    
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alertControllerStyle = UIAlertControllerStyle.alert
        let alertView = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        let alertActionStyle = UIAlertActionStyle.default
        let alertActionOK = UIAlertAction(title: actionTitle, style: alertActionStyle, handler: nil)
        alertView.addAction(alertActionOK)
        DispatchQueue.main.async(execute: {
            self.present(alertView, animated: true, completion: nil)
        })
    }
}

struct Messages {
    static let loginError = "Your username and/or password may be incorrect. Please update your information again."
    static let networkError = "Cannot connect to Udacity due to connection issue. Please try again."
    static let noInternet = "Please connecto to internet and try again."
    static let cannotPost = "Posting user location failed, try again"
    static let failedToPost = "Failed to post your information. Please try Again"
    static let addressNotFound = "We couldn't find your address. Please try Again"
}

extension UIActivityIndicatorView {
    func hide() {
        DispatchQueue.main.async(execute: {
            self.stopAnimating()
            self.removeFromSuperview()
        })
    }
}

enum Result {
    case OK, FAILED
}
