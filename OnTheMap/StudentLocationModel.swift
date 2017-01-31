//
//  StudentLocationModel.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/30/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation

// StudentInformation
struct StudentLocationModel {
    
    // Student Location Model information
    static let objectIdKey = "objectId"
    static let uniqueKey = "uniqueKey"
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let mapStringKey = "mapString"
    static let mediaURLKey = "mediaURL"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let createdAtKey = "createdAt"
    static let updatedAtKey = "updatedAt"
    
    static var student = [StudentModel]()
    
    // Getting list of Student
    static func getStudentList(_ newStudents: [[String: Any]]) {
        student.removeAll()
        
        // Looping in students
        for eachStudent in newStudents {
            
            guard let newStudent = StudentModel(student: eachStudent) else {
                return
            }

            // Append student in students to the list
            StudentLocationModel.student.append(newStudent)
        }
    }

}
