//
//  StudentModel.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/30/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation

// StudentInformation Model
struct StudentModel {
    
    // Model structed from StudentLocationModel
    
    var objectIdKey: String
    var uniqueKey: String
    var firstNameKey: String
    var lastNameKey: String
    var mapStringKey: String
    var mediaURLKey: String
    var latitudeKey: Double
    var longitudeKey: Double
    var createdAtKey: String
    var updatedAtKey: String
    // ACL not needed
    //var ACLKey: String
    
    // Initializing properties for StudentModel usage
    init?(student: [String:Any]) {
        
        // initialize with Nil-Coalescing Operator !=nil ? X: Y
        objectIdKey = student[StudentLocationModel.objectIdKey] != nil ? student[StudentLocationModel.objectIdKey] as! String: ""
        uniqueKey = student[StudentLocationModel.uniqueKey] != nil ? student[StudentLocationModel.uniqueKey] as! String: ""
        firstNameKey = student[StudentLocationModel.firstNameKey] != nil ? student[StudentLocationModel.firstNameKey] as! String: ""
        lastNameKey = student[StudentLocationModel.lastNameKey] != nil ? student[StudentLocationModel.lastNameKey] as! String: ""
        mapStringKey = student[StudentLocationModel.mapStringKey] != nil ? student[StudentLocationModel.mapStringKey] as! String: ""
        mediaURLKey = student[StudentLocationModel.mediaURLKey] != nil ? student[StudentLocationModel.mediaURLKey] as! String: ""
        latitudeKey = student[StudentLocationModel.latitudeKey] != nil ? student[StudentLocationModel.latitudeKey] as! Double: 0
        longitudeKey = student[StudentLocationModel.latitudeKey] != nil ? student[StudentLocationModel.longitudeKey] as! Double: 0
        createdAtKey = student[StudentLocationModel.createdAtKey] != nil ? student[StudentLocationModel.createdAtKey] as! String: ""
        updatedAtKey = student[StudentLocationModel.updatedAtKey] != nil ? student[StudentLocationModel.updatedAtKey] as! String: ""
    }
    
}
