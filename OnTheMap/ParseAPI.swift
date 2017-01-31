//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/29/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation

struct ParseAPI {
    
    // base url for networking
    static let url = NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation\(parameters)")
    static let parameters = "?limit=100&order=-updatedAt"
    static let urlPost = NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")

    // shared Session
    static let session = URLSession.shared

    // get the map data
    static func getMapData(callback: @escaping (Result) -> Void) -> Void {
        
        guard let url = ParseAPI.url else {
            return
        }

        let request = NSMutableURLRequest(url: url as URL)
        
        // Add key & ID to the request
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error
                return
            }
            
            guard let data = data else {
                return
            }
            
            // Json serialization of data
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] {
                    if let studentInformationArray = json["results"] as? [[String:AnyObject]] {
                        StudentLocationModel.getStudentList(studentInformationArray)
                        //print(studentInformationArray)
                        callback(Result.OK)
                    } else {
                        print("Getting Student List Failed")
                        callback(Result.FAILED)
                    }
                }
            } catch {
                print("Getting Student List Failed")
                callback(Result.FAILED)
            }
        }
        task.resume()
    }
    
    // To create a new student location
    static func postNewStudentLocation (completion: @escaping RequestCompletionHandler) {
        
        guard let urlPost = ParseAPI.urlPost else {
            return
        }
        
        let request = NSMutableURLRequest(url: urlPost as URL)
        
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBodyString = "{\"uniqueKey\": \"\(User.uniqueKey)\", \"firstName\": \"\(User.firstName)\", \"lastName\": \"\(User.lastName)\",\"mapString\": \"\(User.mapString)\", \"mediaURL\": \"\(User.mediaURL)\",\"latitude\": \(User.latitude), \"longitude\": \(User.longitude)}"
        print("This is the bodyString of the current User: ", httpBodyString)
        request.httpBody = httpBodyString.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard completion != nil else {
                return
            }
            
            completion(data, response, error)
        }
        task.resume()
    }
}






