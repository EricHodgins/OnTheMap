//
//  TabBarController.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var on: Bool = true

    @IBAction func logoutPressed(sender: AnyObject) {
        print("logout pressed")
        dismissViewControllerAnimated(true, completion: nil)
        OTMClient.sharedInstance.logoutSessionFromUdacity { (success, error) -> Void in
            if success {
                print("successfully logged out of Udacity.")
            } else {
                print("Could not logout user.")
                print(error?.localizedDescription)
            }
        }
        
        if OTMClient.sharedInstance.facebookLoggedIn {
            OTMClient.sharedInstance.facebookLogout()
        }
        
    }
    
    @IBAction func refreshStudentData(sender: UIBarButtonItem) {
        print("refreshing")
        if OTMClient.internetConnectionStatusIsConnected() {
            refresh()
        } else {
          alertUserThereIsNoInternetConnection("Could not refresh map.")
        }
    }
    
    
    
    // check to see if the TabBarController viewControllers conform to the Refresh & RefreshTable protocol
    func refresh() {
        
        for vc in viewControllers! {
            if vc.conformsToProtocol(RefreshTable) {
                // this just activates the activity view to show the user something is loading if they're looking at the table
                let studentsTablviewVC = vc as! RefreshTable
                studentsTablviewVC.refreshingTable()
            }
            
            if vc.conformsToProtocol(Refresh) {
                let viewController = vc as! Refresh
                viewController.refresh() { finished in
                    if finished {
                        let studentsTableView = self.viewControllers![1] as? StudentsTableViewController
                        studentsTableView?.refreshTableView()
                    } else {
                        print("error refreshing student data.")
                        self.alertUnableToRefreshStudentData()
                        let studentTable = self.viewControllers![1] as? StudentsTableViewController
                        studentTable?.deactivateActivityView()
                    }
                }
            }
        }
    }
    
    
    @IBAction func removeUserFromTheMap(sender: AnyObject) {
        print("Tab bar pressed for removing user from map.")
        if OTMClient.internetConnectionStatusIsConnected() {
            (viewControllers![0] as? MapViewController)?.removePin()
        } else {
            alertUserThereIsNoInternetConnection("Could not remove user")
        }
    }
    
    
    @IBAction func showDropPinViewController(sender: AnyObject) {
        print("show drop pin.")
        
        if OTMClient.internetConnectionStatusIsConnected() {
        
            OTMClient.sharedInstance.queryForStudent { (JSONResult, errorString) -> Void in

                if errorString == nil {
                    if let studentInfo = JSONResult {
                        // if the student is already on the map or on parse update info otherwise add new student info
                        if OTMClient.sharedInstance.studentExists {
                            OTMClient.updateOTMClientSharedInstanceWithStudentObject(studentInfo)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.askUserToUpdate()
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.instantiateDropPinViewController()
                            }
                        }
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.alertUserCouldNotUpdatePosition(errorString)
                    }
                }
            }
        } else {
            alertUserThereIsNoInternetConnection("Could not drop new map pin.")
        }
    }
    
    func instantiateDropPinViewController() {
        let dropPinController = self.storyboard?.instantiateViewControllerWithIdentifier("DropPin") as? DropPinViewController
        presentViewController(dropPinController!, animated: true, completion: nil)
    }
    

}

