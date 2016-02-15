//
//  MapViewControllerUI.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-01.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

extension MapViewController {
    
    func deactivateActivityView() {
        activityView.stopAnimating()
        activityView.hidden = true
        view.alpha = 1.0
    }
    
    func activateActvityView() {
        activityView.hidden = false
        activityView.startAnimating()
        view.alpha = 0.5
    }
    
    func verifyToRemovePin(handler: (remove: Bool) -> Void) {
        let alertController = UIAlertController(title: "Remove Your Pin?", message: "Are you sure you want to remove your pin from the map?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) -> Void in
            print("Yes action.")
            handler(remove: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in
            print("No action.")
            handler(remove: false)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func notifyUserDoesNotExist() {
        let alertController = UIAlertController(title: "Nothing to remove.", message: "You're not on the map yet!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func notifyUserWasNotRemoved(errorMessage: String?) {
        
        var message = ""
        if errorMessage != nil {
            message = "\(errorMessage!)"
        } else {
            message = "Network error."
        }
        
        let alertController = UIAlertController(title: "Unable to remove student", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertUserInvalidLink(errorMessage: String) {
        let alertController = UIAlertController(title: "Unable to open link", message: errorMessage, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
