//
//  DropPinUI.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-01.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

extension DropPinViewController {

    func handleUIUpdate() {
        //hide the "Where are you studying today?" labels
        for label in topLabels {
            label.hidden = true
        }
        
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        // Show the share link textView & hide the location textview
        shareLinkTextView.hidden = false
        locationTextView.hidden = true
        
        submitButton.hidden = true
        findOnMapButton.hidden = true
    }
    
    func finishedLoadingUI() {
        //change the topView color to blue
        topView.backgroundColor = UIColor(red: 75.0/255.0, green: 136.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        bottomView.alpha = 0.6
        
        submitButton.hidden = false
    }
    
    func customizeButtons() {
        submitButton.layer.cornerRadius = 8.0
        findOnMapButton.layer.cornerRadius = 8.0
    }
    
    func alertUserLocationNotFound() {
        let alertController = UIAlertController(title: "Could not find location.", message: "The map string could not be geocoded.", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
        restoreOriginalUI()
    }
    
    
    func alertUserCouldNotPostStudentInfo(errorMessage: String) {
        let alertController = UIAlertController(title: "Could not save data.", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
        view.alpha = 1.0
        activityView.stopAnimating()
    }
    
    func alertUserThereIsNoInternetConnection(message: String) {
        let alertController = UIAlertController(title: message, message: "There is no internet connection", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    func restoreOriginalUI() {
        for label in topLabels {
            label.hidden = false
        }
        
        findOnMapButton.hidden = false
        shareLinkTextView.hidden = true
        mapView.hidden = true
        cancelButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), forState: .Normal)
        locationTextView.hidden = false
        locationTextView.text = "Try it again! Check your spelling."
    }
    
    
    
    func submittingStudentInfoUI() {
        view.alpha = 0.5
        activityView.hidden = false
        middleView.bringSubviewToFront(activityView)
        activityView.startAnimating()
    }
    
    func activateActivityView() {
        activityView.hidden = false
        activityView.startAnimating()
    }
    
    func deactivateActivityView() {
        activityView.stopAnimating()
    }
    
}
