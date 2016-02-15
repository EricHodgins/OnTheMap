//
//  OTMClient.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-18.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import SystemConfiguration

class OTMClient {
    
    var reachability: Reachability? // This is used to check if the device has an internet connection via Wifi or WWAN
    var facebookLoggedIn: Bool = false
    
    var firstName : String? = nil
    var lastName : String? = nil
    var userId : String? = nil // key, uniqueKey
    var userObjectId: String? = nil // id generated from parse
    var studentExists: Bool = false
    var allStudents = [OTMStudent]() // holds all student structs
    
    var session: NSURLSession
    
    
    // Setup Singelton instance
    static let sharedInstance = OTMClient()
    
    // prevents others from using the default initilizer for this class
    private init() {
        session = NSURLSession.sharedSession()
        reachability = Reachability.reachabilityForInternetConnection()
        reachability?.startNotifier()
    }
    
    
    //helper methods
    //Checking errors & response is valid for reponses from PARSE or Udacity
    func errorAndReponseIsValid(response: NSURLResponse?, error: NSError?, domain: String, completionHandler:(result: AnyObject!, error: NSError?) -> Void) -> Bool {
        guard error == nil else {
            print("Error with request: \(error)")
            completionHandler(result: nil, error: error)
            return false
        }
        
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            if let response = response as? NSHTTPURLResponse {
                if response.statusCode >= 400 && response.statusCode <= 499 {
                    completionHandler(result: nil, error: NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey : "Username or password is incorrect."]))
                    return false
                }
                
                completionHandler(result: nil, error: NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey : "Request returned an invalide response: \(response.statusCode)"]))
                return false
                
            } else if let response = response {
                completionHandler(result: nil, error: NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey : "Request returned invalid response: \(response)"]))
                return false
            } else {
                completionHandler(result: nil, error: NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey : "Request returned an invalid response: \(response)"]))
                return false
            }
        }
        
        
        return true
    }
    
    
    //MARK: Parse JSON data
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler:(result : AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data to JSON: \(data)"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONCompletionHandler", code: 0, userInfo: userInfo))
        }
        
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    
    
    //MARK: Convert a string to a url
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key, value) in parameters {
            // Make sure value is a string
            let stringValue = "\(value)"
            
            // Escape it for a URL format
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            urlVars += [key + "=\(escapedValue!)"]
            
        }
        
        if !urlVars.isEmpty {
            return "?" + urlVars.joinWithSeparator("&")
        } else {
            return ""
        }
    }
    
    //MARK: Check if the device has a internet connection
    
    // use the Reachability class to check if the device has access to the internet via wifi or wwan
    class func internetConnectionStatusIsConnected() -> Bool {
        
        if OTMClient.sharedInstance.reachability?.currentReachabilityStatus().rawValue == NotReachable.rawValue {
            return false
        }
        
        return true
    }
    
    
    //MARK: Update OTMClient
    class func updateOTMClientSharedInstanceWithStudentObject(studentObject: [String : AnyObject]) {
        print("updating student info from query....\(studentObject)")
        print(studentObject["uniqueKey"] as? String)
        OTMClient.sharedInstance.userId = studentObject[OTMClient.StudentProperties.uniqueKey] as? String
        OTMClient.sharedInstance.userObjectId = studentObject[OTMClient.StudentProperties.objectId] as? String
        OTMClient.sharedInstance.firstName = studentObject[OTMClient.StudentProperties.firstName] as? String
        OTMClient.sharedInstance.lastName = studentObject[OTMClient.StudentProperties.lastName] as? String
        OTMClient.sharedInstance.studentExists = true
    }
    
}










