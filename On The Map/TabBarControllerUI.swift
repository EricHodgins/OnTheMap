//
//  TabBarControllerUI.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-07.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import UIKit

extension TabBarController {
    
    
    // Alert user Refresh did not work
    func alertUnableToRefreshStudentData() {
        let alertController = UIAlertController(title: "Unable to refresh.", message: "Could not update student data.", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Alert user there is no internet
    func alertUserThereIsNoInternetConnection(message: String) {
        let alertController = UIAlertController(title: message, message: "There is no internet connection", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Ask user if they would like to update their info
    func askUserToUpdate() {
        let alertController = UIAlertController(title: "You're alredy on the map", message: "Would you like to overwrite your data?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.instantiateDropPinViewController()
            }
        }
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Alert user could not update position..network request did not work
    func alertUserCouldNotUpdatePosition(errorMessage: String?) {
        let alertController = UIAlertController(title: "Unable to update", message: errorMessage!, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}