//
//  MapViewController.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-16.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//
// GFbUFBck3Y,
// MwmF6oNgSo

import UIKit
import MapKit

class MapViewController: UIViewController, Refresh {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var studentLocations: [[String : AnyObject]]?
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set mapView delegate
        mapView.delegate = self
        let tabBarVC = tabBarController as! TabBarController
        //getStudentLocationData(nil)
        tabBarVC.refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    //MARK: Get students location info
    func refresh(completionHandler: (finished: Bool) -> Void) {
        getStudentLocationData(completionHandler)
    }
    
    func getStudentLocationData(completionHandler: ((finished: Bool) -> Void)?) {
        activateActvityView()
        
        OTMClient.sharedInstance.getStudentsFromParse { (success, results, errorString) -> Void in
            if success {
                let students = OTMStudent.studentsFromResults(results!)
                let annotations = OTMStudent.makeMapAnnotationsFromStudents(students)
                OTMClient.sharedInstance.allStudents = students
                OTMClient.sharedInstance.studentExists = OTMStudent.doesStudentExist(students)
                dispatch_async(dispatch_get_main_queue()) {
                    if self.mapView.annotations.count != 0 {
                        self.mapView.removeAnnotations(self.mapView.annotations)
                    }

                    self.mapView.addAnnotations(annotations)
                    self.deactivateActivityView()
                    
                    // Once the student data is collected the Student Table View can be updated
                    if completionHandler != nil {
                        completionHandler!(finished: true)
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler!(finished: false)
                    self.deactivateActivityView()
                }
            }
        }
        
    }
    
    //MARK: Remove User from the map
    func removePin() {

        if OTMClient.sharedInstance.userObjectId == nil {
            notifyUserDoesNotExist()
        } else {
        
                verifyToRemovePin() { remove in
                
                if OTMClient.sharedInstance.userObjectId != nil && remove {
                    self.activateActvityView()
                    OTMClient.sharedInstance.removeStudentFromMap { (success, errorString) -> Void in
                        if success {
                            OTMClient.sharedInstance.userObjectId = nil
                            // Refresh both the map and the tableview
                            (self.tabBarController as? TabBarController)?.refresh()
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                print(errorString)
                                self.notifyUserWasNotRemoved(errorString)
                                self.deactivateActivityView()
                            }
                        }
                    }
                }
            }
        }
    }
}

    //MARK: Map view delegate methods
extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                let sharedURL = NSURL(string: toOpen)!
                if UIApplication.sharedApplication().canOpenURL(sharedURL) {
                    let app = UIApplication.sharedApplication()
                    app.openURL(sharedURL)
                } else {
                    alertUserInvalidLink("Not a valid link.")
                }
            }
        }
    }

}
