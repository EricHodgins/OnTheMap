//
//  StudentsTableViewUI.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-02-10.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import UIKit

extension StudentsTableViewController {
    
    func alertUserInvalidLink(errorMessage: String) {
        let alertController = UIAlertController(title: "Unable to open link", message: errorMessage, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}