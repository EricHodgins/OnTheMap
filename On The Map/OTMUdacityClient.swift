//
//  OTMUdacityClient.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-04.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation

extension OTMClient {
    
    
    //UDACITY GET User data
    func taskForGETUserData(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        let urlString : String = OTMClient.Constants.UdacityBaseURL + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            //GAURD: Check there is no error and the response is okay
            guard self.errorAndReponseIsValid(response, error: error, domain: "taskForGETUserData", completionHandler: completionHandler) else {
                return
            }
            
            
            //GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data to make valid JSON data */
            
            OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    
    
    //MARK: POST
    
    // Get session id from udacity to log in
    func taskForPOSTUdacitySessionMethod(method: String, jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let urlString = OTMClient.Constants.UdacityBaseURL + OTMClient.Methods.UdacitySession
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert jsonBody into JSON data
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Guard: Make sure there was not an error and the response was valid
            guard self.errorAndReponseIsValid(response, error: error, domain: "taskForPOSTUdacitySessionMethod", completionHandler: completionHandler) else {
                return
            }
            
            // Guard: Make sure there was data returned.
            guard var data = data else {
                print("No data was returned.")
                return
            }
            
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    
    //MARK: DELETE
    
    //UDACITY
    func logoutSessionFromUdacity(completionHandler: (success: Bool, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                print("Could not logout: \(error)")
                completionHandler(success: false, error: NSError(domain: "logoutSessionFromUdacity", code: 0, userInfo: [NSLocalizedDescriptionKey : "could not logout user."]) )
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            completionHandler(success: true, error: nil)
        }
        task.resume()
    }

}