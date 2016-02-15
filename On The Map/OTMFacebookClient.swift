//
//  OTMFacebookClient.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-07.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

extension OTMClient {
    
    //MARK: POST to login and get session
    
    func authenticateWithFacebookFromViewController(viewController: UIViewController!, completionHandler: (success: Bool, results: AnyObject!, error: String?) -> Void) {
        FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email"], fromViewController: viewController) { (result, error) -> Void in
            if error != nil {
                completionHandler(success: false, results: nil, error: error.localizedDescription)
                return
            }
            
            if result.token == nil {
                completionHandler(success: false, results: nil, error: "Could not retrieve token string from facebook.")
                return
            }
            
            self.createSessionWithFacebook(result.token.tokenString!, completionHandler: { (results, error) -> Void in
                if error != nil {
                    completionHandler(success: false, results: nil, error: error?.localizedDescription)
                    return
                }
                
                if let account = results["account"] as? [String : AnyObject] {
                    OTMClient.sharedInstance.facebookLoggedIn = true
                    completionHandler(success: true, results: account, error: nil)
                } else {
                    print("could not find a account key with the JSON data")
                    completionHandler(success: false, results: nil, error: "No known key from JSON data.")
                }
            })

        }
    }
    
    func createSessionWithFacebook(tokenString: String, completionHandler: (results: AnyObject!, error: NSError?) -> Void) {
        
        let urlString = OTMClient.Constants.UdacityBaseURL + OTMClient.Methods.UdacitySession
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = [
            "facebook_mobile" : [
                "access_token" : "\(tokenString)"
            ]
        
        ]
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        } catch {
            completionHandler(results: nil, error: NSError(domain: "createSessionWithFacebook", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid token string from Facebook"]))
        }
        
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard self.errorAndReponseIsValid(response, error: error, domain: "createSessionWithFacebook", completionHandler: completionHandler) else {
                return
            }
            
            // Guard: Make sure there was data returned.
            guard let data = data else {
                print("No data was returned.")
                completionHandler(results: nil, error: NSError(domain: "createSessionWithFacebook", code: 0, userInfo: [NSLocalizedDescriptionKey : "No valid data returned from Udacity server."]))
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        task.resume()
    }
    
    //MARK: Logout
    
    func facebookLogout() {
        FBSDKLoginManager().logOut()
        print("logged out of Facebook")
    }
    
}