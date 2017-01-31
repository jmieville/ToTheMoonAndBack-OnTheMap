//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/26/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInText: UILabel!
    @IBOutlet weak var logInBtnText: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    //Actions
    // Log in: if correct username -> present TabBarController else show error message
    
    @IBAction func logInAction(_ sender: Any) {
        // dismiss the keyboard
        dismissKeyboard()
        guard connectedToNetwork() else {
            self.presentAlert(title: "Not Online", message: Messages.noInternet, actionTitle: "Return", actionHandler: nil)
            return
        }
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        let spin = showSpinner()
        
        // POST log in credential to UDACITY API
        UdacityAPI.signInWithUsername(username: username, password: password) {
            (data, response, error) in
            spin.hide()
            // If successful response then let log in
            guard let data = data else {
                return
            }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] {
                        if let accountDict = json["account"] as? [String:AnyObject] {
                            User.uniqueKey = accountDict["key"] as! String
                            DispatchQueue.main.async(execute: {
                                // showMapView
                                if let showMapView = self.storyboard?.instantiateViewController(withIdentifier: "TabNavBarController") {
                                    self.present(showMapView, animated: true, completion: nil)
                                }
                            })
                        } else {
                            // can't log in, invalid user. show UIAlertView or UIAlertController
                            self.presentAlert(title: "Incorrect Credential", message: Messages.loginError, actionTitle: "Okay")
                            print("error due to wrong username and/or password")
                        }
                    }
                } catch {
                }
        }
    }
    
    //Variables/Constants
    
    //Lifecycle methods
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        // Set textField delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Set logInBtnText forState
        logInBtnText.setTitle("Logging in.... Please wait.", for: .disabled)
        logInBtnText.setTitle("Log in", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // extension
    // move frame on y axis for keyboard
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if emailTextField.isFirstResponder {
            setFrame(notification)
            setBlur()
        } else if passwordTextField.isFirstResponder {
            resetFrame()
            setFrame(notification)
            setBlur()
        }
    }
    
    func setBlur() {
        blurEffect.alpha = 1
    }
    func resetBlur() {
        blurEffect.alpha = 0
    }
    
    func keyboardWillHide(_ notification: Notification) {
        resetFrame()
        resetBlur()
    }
    
    func setFrame(_ notification: Notification) {
        self.view.frame.origin.y =  getKeyboardHeight(notification as Notification) * -1
    }
    
    func resetFrame() {
        view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
