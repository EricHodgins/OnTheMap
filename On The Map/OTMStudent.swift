//
//  OTMStudent.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-16.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import MapKit

struct OTMStudent {
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    
    var objectId: String?
    var uniqueKey: String?
    var updated: String?
    
    
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mediaURL = dictionary["mediaURL"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        objectId = dictionary["objectId"] as? String
        mapString = dictionary["mapString"] as? String
    }
    
    
    // Helper functions
    // make students array
    static func studentsFromResults(results: [[String : AnyObject]]) -> [OTMStudent] {
        var students = [OTMStudent]()
        
        for student in results {
            students.append(OTMStudent(dictionary: student))
        }
        
        return students
    }
    
    // make student map annotations
    static func makeMapAnnotationsFromStudents(dictionary: [OTMStudent]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        // loop through all OTMStudents
        for student in dictionary {
            let lat = CLLocationDegrees(student.latitude!)
            let lon = CLLocationDegrees(student.longitude!)
            
            // create a CLLocationCoordinate2d instance
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = "\(student.mediaURL!)"
            
            annotations.append(annotation)
            
        }
        
        
        return annotations
    }
    
    // check to see if the student exists yet with their userId (key)
    static func doesStudentExist(dictionary: [OTMStudent]) -> Bool {
        
        for student in dictionary {
            if let userId = student.uniqueKey {
                if userId == OTMClient.sharedInstance.userId {
                    print(student)
                    OTMClient.sharedInstance.userObjectId = student.objectId
                    return true
                }
            }
        }
        
        return false
    }
}







