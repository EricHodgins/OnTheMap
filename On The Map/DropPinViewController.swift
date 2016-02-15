//
//  DropPinViewController.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import MapKit


class DropPinViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var topLabels = [UILabel]()

    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var shareLinkTextView: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var pointAnnotation: MKPointAnnotation!
    
    var postingStudentLocationInfoSessionTask : NSURLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabels = [whereAreYouLabel, studyingLabel, todayLabel]
    }
    
    override func viewWillAppear(animated: Bool) {
        customizeButtons()
        submitButton.hidden = true
        shareLinkTextView.hidden = true
        mapView.hidden = true
    }

    @IBAction func dismissViewController(sender: AnyObject) {
        if postingStudentLocationInfoSessionTask != nil {
            postingStudentLocationInfoSessionTask?.cancel()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnTheMapFromText(sender: AnyObject) {
        
        if OTMClient.internetConnectionStatusIsConnected() {
            // handle the UI update
            handleUIUpdate()
            
            //perform the map view search with the textview text
            performMapSearchWithText(locationTextView.text)
        } else {
            alertUserThereIsNoInternetConnection("Could not find on the map.")
        }
    }
    
    @IBAction func submitStudentLocation(sender: AnyObject) {
        
        if OTMClient.internetConnectionStatusIsConnected() {
        
            submittingStudentInfoUI()
            
            let lat : Double = localSearchResponse.boundingRegion.center.latitude
            let lon : Double = localSearchResponse.boundingRegion.center.longitude
            
            // IF the student exists already then UPDATE otherwise POST new student info to Parse
            if OTMClient.sharedInstance.studentExists {
                postingStudentLocationInfoSessionTask = OTMClient.sharedInstance.updateStudentLocation(locationTextView.text!, mediaURL: shareLinkTextView.text!, latitude: lat, longitude: lon, completionHandler: { (success, errorString) -> Void in
                    self.submittingStudentSuccess(success, errorString: errorString)
                })
                
            } else {
            
                postingStudentLocationInfoSessionTask = OTMClient.sharedInstance.submitStudentLocationToParse(locationTextView.text!, mediaURL: shareLinkTextView.text!, latitude: lat, longitude: lon) { (success, objectId, errorString) -> Void in
                    self.submittingStudentSuccess(success, errorString: errorString)
                }
            }
            
        } else {
            alertUserThereIsNoInternetConnection("Could not update student data.")
        }
    }
    
    // helper function for submitting student info
    func submittingStudentSuccess(success: Bool, errorString : String?) {
        if success {
            dispatch_async(dispatch_get_main_queue()) {
                (self.presentingViewController?.childViewControllers[0] as? TabBarController)?.refresh()
                self.deactivateActivityView()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            if errorString != "cancelled" {
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertUserCouldNotPostStudentInfo(errorString!)
                }
            }
        }
    }
    
    
    //MARK: Map Search
    func performMapSearchWithText(searchText: String) {
        activateActivityView()

        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchText
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { localSearchResponse, error in
            if localSearchResponse == nil {
                print("Search was nil.")
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertUserLocationNotFound()
                    self.deactivateActivityView()
                }
                return
            }
            
            print(localSearchResponse)
            self.localSearchResponse = localSearchResponse
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)

            self.mapView.addAnnotation(self.pointAnnotation)
            
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
            
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.hidden = false
            self.mapView.setRegion(region, animated: true)
            self.findOnMapButton.hidden = true
            self.submitButton.hidden = false
            
            dispatch_async(dispatch_get_main_queue()) {
                self.deactivateActivityView()
                self.finishedLoadingUI()
            }

        }
    }
}


//MARK: TextView Delegate Methods

extension DropPinViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        print("begin.")
        if textView.text == "Enter Your Location Here" || textView.text == "Enter A Link To Share" || textView.text == "Try it again! Check your spelling." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == locationTextView && textView.text == "" {
            textView.text = "Enter Your Location Here"
  
        } else if (textView == shareLinkTextView && textView.text == "") {
            textView.text = "Enter A Link To Share"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
