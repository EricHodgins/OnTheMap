//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-22.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import MapKit

class StudentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RefreshTable {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func refreshingTable() {
        if activityView != nil {
            activityView.hidden = false
            activityView.startAnimating()
        }
    }
    
    func deactivateActivityView() {
        if activityView != nil {
            activityView.stopAnimating()
            activityView.hidden = true
        }
    }
    
    func refreshTableView() {
        guard let tableView = tableView else {
            return
        }
        
        tableView.reloadData()
        deactivateActivityView()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        
        return OTMClient.sharedInstance.allStudents.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! CustomStudentCell
            cell.findStudentButton.tag = indexPath.row
            cell.findStudentButton.addTarget(self, action: "locateStudentOnMap:", forControlEvents: .TouchUpInside)
            
            let student = OTMClient.sharedInstance.allStudents[indexPath.row]
            
            cell.studentName?.text = "\(student.firstName!) \(student.lastName!)"

            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("customHeaderCell", forIndexPath: indexPath) as! CustomHeaderCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.section)
        
        if indexPath.section == 1 {
        
            let student = OTMClient.sharedInstance.allStudents[indexPath.row]
            
            if let toOpen = student.mediaURL,
               let sharedURL = NSURL(string: toOpen){
                if UIApplication.sharedApplication().canOpenURL(sharedURL) {
                    let app = UIApplication.sharedApplication()
                    app.openURL(sharedURL)
                } else {
                    alertUserInvalidLink("Not a valid link.")
                }
            } else {
                alertUserInvalidLink("Not a valid link.")
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 161.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150.0
        }
        
        return 63.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 161.0))
        
        return mapView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let topCell = tableView?.visibleCells[0].isKindOfClass(CustomHeaderCell)
        
        if topCell! {
            let cell = tableView?.visibleCells[0]
            let cellBottomPointRelativeToSuperView = tableView?.convertPoint(CGPoint(x: (cell?.center.x)!, y: (cell?.center.y)! + 75), toView: tableView?.superview)
            let navigationBarHeight = (navigationController?.navigationBar.frame.origin.y)! + (navigationController?.navigationBar.frame.height)!
            cell!.alpha = (cellBottomPointRelativeToSuperView!.y - navigationBarHeight) / 150.0
        }
    }
}


extension StudentsTableViewController {
    func locateStudentOnMap(sender: AnyObject) {
        
        let findStudentButton = sender as! UIButton
        let student = OTMClient.sharedInstance.allStudents[findStudentButton.tag]
        print(student.mapString!)
        performMapSearchWithStudent(student)
        
    }
    
    func performMapSearchWithStudent(student: OTMStudent) {
        // zoom out
        let originalSpan = MKCoordinateSpanMake(1, 1)
        let originalRegion = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: 90, longitude: 90), originalSpan)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: 90)
        mapView.setRegion(originalRegion, animated: true)
        
        
        // add the annotation and zoom in to the location
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
        mapView.addAnnotation(pointAnnotation)
        
        let span = MKCoordinateSpanMake(1.0, 1.0)
        let region = MKCoordinateRegionMake(pointAnnotation.coordinate, span)
        
        mapView.centerCoordinate = pointAnnotation.coordinate
        mapView.setRegion(region, animated: true)
        
    }
}


















