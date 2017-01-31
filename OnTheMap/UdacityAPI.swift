//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/27/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation
import UIKit


// Typealias to shorten code
typealias RequestCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

struct UdacityAPI {
    
    // url Method
    static let url = NSURL(string: "https://www.udacity.com/api/session")
    // singleton session
    static let session = URLSession.shared
    
    // signIn request
    static func signInWithUsername(username: String, password: String, completion: RequestCompletionHandler?) {
        
        guard let url = url else {
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            let dataLength = data.count
            let r = 5..<Int(dataLength)
            let newData = data.subdata(in: Range(r))
                        
            if let completion = completion {
                completion(newData, response, error)
            }
        }
        task.resume()
    }
    
    // get public user information
    static func getUserInfo(completion: RequestCompletionHandler?) {
        
        guard let userKeyUrl = NSURL(string: "https://www.udacity.com/api/users/\(User.uniqueKey)") else {
            return
        }
        let request = NSMutableURLRequest(url: userKeyUrl as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            let dataLength = data.count
            let r = 5..<Int(dataLength)
            let newData = data.subdata(in: Range(r))
            
            // Get user's firstname and last name from Udacity's API Log In credential fo later usage in Post Information OnTheMap
            do {
                if let json = try JSONSerialization.jsonObject(with: newData, options: [.allowFragments]) as? [String:AnyObject] {
                    print("userInfoJSON = ", json)
                    if let userDict = json["user"] as? [String:AnyObject] {
                        User.firstName = userDict["first_name"] as! String
                        User.lastName = userDict["last_name"] as! String
                    }
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    // log out
    static func logOut(callback: @escaping (Result) -> Void) -> Void {
        guard let sessionUrl = NSURL(string: "https://www.udacity.com/api/session") else {
          return
        }
        let request = NSMutableURLRequest(url: sessionUrl as URL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                callback(Result.FAILED)
                return
            }
            
            guard let data = data else {
                callback(Result.FAILED)
                return
            }
            
            let dataLength = data.count
            let r = 5..<Int(dataLength)
            let newData = data.subdata(in: Range(r))
            callback(Result.OK)
        }
        task.resume()
    }
}
