//
//  OTMParseClient.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-04.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation

extension OTMClient {
    
    //MARK: GET
    
    //PARSE
    func taskForPARSEGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result : AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString : String = OTMClient.Constants.ParseBaseURL + method + OTMClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(OTMClient.HeaderKeys.PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.HeaderKeys.PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            //GAURD: Error?
            
            guard self.errorAndReponseIsValid(response, error: error, domain: "taskForPARSEGETMethod", completionHandler: completionHandler) else {
                return
            }
            
            //GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            //Parse the data and pass back to completion handler
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        // Start the request
        task.resume()
        
        return task
    }

    
    
    //MARK: POST
    
    func taskForPOSTStudentLocation(method: String, jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let urlString = OTMClient.Constants.ParseBaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(OTMClient.HeaderKeys.PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.HeaderKeys.PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert jsonBody into JSON data
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Guard: Make sure there was not an error
            
            guard self.errorAndReponseIsValid(response, error: error, domain: "taskForPOSTStudentLocation", completionHandler: completionHandler) else {
                return
            }
            
            // Guard: Make sure there was data returned.
            guard let data = data else {
                print("No data was returned.")
                return
            }
            
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
        
    }
    
    
    //MARK: DELETE
    
    //PARSE
    func taskForPARSEDELETEMethod(method: String, completionHandler: (success : Bool, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let urlString : String = OTMClient.Constants.ParseBaseURL + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        request.addValue(OTMClient.HeaderKeys.PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.HeaderKeys.PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                print("Error removing user from parse: \(error)")
                completionHandler(success: false, error: NSError(domain: "taskForPARSEDELETEMethod", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not remove student. \(error!.localizedDescription)"]))
                return
            }
            
            completionHandler(success: true, error: nil)
        }
        
        
        task.resume()
        return task
    }
    
    
    //MARK: QUERY (GET request)for student
    
    func taskForPARSEQueryForStudent(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let methodWithQuery = method.stringByReplacingOccurrencesOfString("{value}", withString: "\"\(OTMClient.sharedInstance.userId!)\"")
        let urlString : String = OTMClient.Constants.ParseBaseURL + methodWithQuery.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(OTMClient.HeaderKeys.PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.HeaderKeys.PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard self.errorAndReponseIsValid(response, error: error, domain: "taskForPARSEQueryForStudent", completionHandler: completionHandler) else {
                return
            }

            guard let data = data else {
                print("No query data.")
                return
            }
            
            print("QUERIED FOR STUDENT")
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    
    //MARK: UPDATING student location
    
    func taskForPARSEUpdateStudent(method: String, jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        let urlString = OTMClient.Constants.ParseBaseURL + method
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(OTMClient.HeaderKeys.PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.HeaderKeys.PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
          request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        

        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard self.errorAndReponseIsValid(response, error: error, domain: "taskForPARSEUpdateStudent", completionHandler: completionHandler) else {
                return
            }
            
            guard let data = data else {
                print("No put data.")
                completionHandler(result: nil, error: NSError(domain: "taskForPARSEUpdateStudent", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not update.  Invalid data returned from server."]))
                return
            }

            completionHandler(result: data, error: nil)
            
        }
        task.resume()
        
        return task
    }
    
    
}
































