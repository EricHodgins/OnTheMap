//
//  OTMConstants.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-23.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation


extension OTMClient {
    
    //MARK: Constants
    struct Constants {
        
        static let UDACITY_SERVER = "UDACITY"
        static let PARSE_SERVER = "PARSE"
        
        //Udacity
        static let UdacityBaseURL : String = "https://www.udacity.com/"
        
        //Parse
        static let ParseBaseURL : String = "https://api.parse.com/"
    }
    
    
    //MARK: Methods
    struct Methods {
        static let UdacitySession = "api/session"
        static let UdacityPublicUserData = "api/users/{user_id}"
        
        //Parse
        static let StudentLocations = "1/classes/StudentLocation"
        static let removeStudentPin = "1/classes/StudentLocation/{object_id}/"
        static let queryForStudent = "1/classes/StudentLocation?where={\"uniqueKey\":{value}}"
        static let updateStudent = "/1/classes/StudentLocation/{object_id}/"
    }
    
    //MARK: URL Keys
    struct URLKeys {
        
    }
    
    //MARK: Response Header Keys
    struct HeaderKeys {
        static let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let PARSE_REST_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let limit = "limit" // max number of students to retrieve
        static let skip = "skip" // to paginate through results
        static let order = "order" // order of students. Default is descending...(updatedAt or -updatedAt)
        
        static let objectId = "{object_id}"
    }
    
    //MARK: Studen Info Keys
    struct StudentProperties {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let createdAt = "createdAt"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        
    }
}






