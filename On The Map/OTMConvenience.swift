//
//  OTMConvenience.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-23.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation

extension OTMClient {
    
    //MARK: GET
    
    //GET all student information
    func getStudentsFromParse(completionHandler: (success: Bool, results: [[String : AnyObject]]?, errorString: String?) -> Void) {
        //1. set the parameters
        
        let parameters = [
            OTMClient.ParameterKeys.limit : 100
        ]
        
        taskForPARSEGETMethod( OTMClient.Methods.StudentLocations, parameters: parameters) { JSONResult, error in
            print("getStudentsFromParseCOmpletionHandler:")
            if let error = error {
                print(error)
                completionHandler(success: false, results: nil, errorString: error.localizedDescription)
            } else {
                if let results = JSONResult["results"] as? [[String : AnyObject]] {
                    completionHandler(success: true, results: results, errorString: nil)
                } else {
                    print("Could not find results from in: \(JSONResult)")
                    completionHandler(success: false, results: nil, errorString: "Could not parse results for Student data.")
                }
            }
        }
    }
    
    
    func getUserData(completionHandler: (success: Bool, results: [String : AnyObject]?, errorString: String?) -> Void) {
        
        let method = OTMClient.Methods.UdacityPublicUserData
        let methodWithUserId = method.stringByReplacingOccurrencesOfString("{user_id}", withString: OTMClient.sharedInstance.userId!)
        
        taskForGETUserData(methodWithUserId) { (JSONResult, error) -> Void in
            if let error = error {
                print(error)
                completionHandler(success: false, results: nil, errorString: "Could not get User Data from Udacity. \(error.localizedDescription)")
            } else {
                if let results = JSONResult["user"] as? [String : AnyObject] {
                    completionHandler(success: true, results: results, errorString: nil)
                } else {
                    print("Could not parse user data: \(JSONResult)")
                    completionHandler(success: false, results: nil, errorString: "Could not parse results for getting User Data.")
                }
            }
        }
    }
    
    
    //MARK: POST
    
    func createUdacitySessionWithPOST(email: String, password: String, completionHandler: (success: Bool, results: [String : AnyObject]?, error: String?) -> Void) -> NSURLSessionTask? {
        let method = OTMClient.Methods.UdacitySession
        
        let jsonBody = [
            "udacity" : [
                "username" : email,
                "password" : password
            ]
        ]
        
        return taskForPOSTUdacitySessionMethod(method, jsonBody: jsonBody) { (JSONresult, error) -> Void in
            if let error = error {
                print("error occurred during POSTing to get Udacity Session id: \(error)")
                completionHandler(success: false, results: nil, error:  "\(error.localizedDescription as String)")
            } else {
                if let account = JSONresult["account"] as? [String : AnyObject] {
                    completionHandler(success: true, results: account, error: nil)
                } else {
                    print("could not find a account key with the JSON data")
                    completionHandler(success: false, results: nil, error: nil)
                }
            }
        }
    }
    
    func submitStudentLocationToParse(mapString : String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, objectId: String?, errorString: String?) -> Void) -> NSURLSessionTask {
        let method = OTMClient.Methods.StudentLocations
        
        print(OTMClient.sharedInstance.userId)
        print(OTMClient.sharedInstance.firstName)
        print(OTMClient.sharedInstance.lastName)
        
        
        let jsonBody : [String : AnyObject] = [
            "uniqueKey" : OTMClient.sharedInstance.userId!,
            "firstName" : OTMClient.sharedInstance.firstName!,
            "lastName" : OTMClient.sharedInstance.lastName!,
            "mapString" : mapString,
            "mediaURL" : mediaURL,
            "latitude" : latitude,
            "longitude" : longitude
        ]
        
        return taskForPOSTStudentLocation(method, jsonBody: jsonBody) { (JSONresult, error) -> Void in
            if let error = error {
                print("Error occurred POSTing student data to Parse: \(error)")
                completionHandler(success: false, objectId: nil, errorString: "\(error.localizedDescription)")
            } else {
                if let objectId = JSONresult["objectId"] as? String {
                    OTMClient.sharedInstance.userObjectId = objectId
                    completionHandler(success: true, objectId: OTMClient.sharedInstance.userObjectId, errorString: nil)
                } else {
                    print("could not parse for object id in POSTing to Parse.")
                    completionHandler(success: false, objectId: nil, errorString: "Could not parse for objectId.")
                }
            }
        }
    }
    
    
    
    //MARK: DELETE
    
    //PARSE
    func removeStudentFromMap(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let method = OTMClient.Methods.removeStudentPin
        let methodWithObjectId = method.stringByReplacingOccurrencesOfString("{object_id}", withString: OTMClient.sharedInstance.userObjectId!)
        
        taskForPARSEDELETEMethod(methodWithObjectId) { (success, error) -> Void in
            if success {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: error?.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: QUERY
    func queryForStudent(completionHandler: (result: [String : AnyObject]?, errorString: String?) -> Void) {
        let method = OTMClient.Methods.queryForStudent
        
        taskForPARSEQueryForStudent(method) { (JSONResult, error) -> Void in
            if error == nil {
                if let results = JSONResult["results"] as? [[String : AnyObject]] {
                    print("=======")
                    print(results.count)
                    if results.count == 0 {
                        completionHandler(result: ["student" : "none"], errorString: nil)
                    } else {
                        completionHandler(result: results[0], errorString: nil)
                    }
                }
                
            } else {
                print(error)
                completionHandler(result: nil, errorString: error!.localizedDescription)
            }
        }
        
    }
    
    //MARK: PUT (update Student location)
    func updateStudentLocation(mapString : String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void) -> NSURLSessionTask {
        
        let jsonBody : [String : AnyObject] = [
            "uniqueKey" : OTMClient.sharedInstance.userId!,
            "firstName" : OTMClient.sharedInstance.firstName!,
            "lastName" : OTMClient.sharedInstance.lastName!,
            "mapString" : mapString,
            "mediaURL" : mediaURL,
            "latitude" : latitude,
            "longitude" : longitude
        ]
        
        let method = OTMClient.Methods.updateStudent
        let methodWithObjectId = method.stringByReplacingOccurrencesOfString("{object_id}", withString: OTMClient.sharedInstance.userObjectId!)
        
        
        return taskForPARSEUpdateStudent(methodWithObjectId, jsonBody: jsonBody) { (JSONresult, error) -> Void in
            if error == nil {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: error!.localizedDescription)
            }
        }
        
    }

    
    
}