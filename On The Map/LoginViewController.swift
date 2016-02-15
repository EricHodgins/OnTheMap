//
//  LoginViewController.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-14.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actvityView: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    var loginSession: NSURLSessionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTextFields()
        
        emailTextField.delegate = self;
        passwordTextField.delegate = self;
        
        //Configure tap recognizer to hide keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        
        configUI()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        actvityView.hidden = true
    }

    @IBAction func signupWithUdacityButtonPressed(sender: AnyObject) {
        let url = NSURL(string: OTMClient.Constants.UdacityBaseURL)!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    // get the session id from Udacity
    @IBAction func loginButtonPressed(sender: AnyObject) {
        facebookButton.enabled = false
        if OTMClient.internetConnectionStatusIsConnected() {
            activateActvityView()
            
            if loginSession != nil {
                loginSession?.cancel()
            }
            
            createUdacitySession()
            
        } else {
            setupAlertView("There is not a internet connection.")
        }
    }
    
    @IBAction func loginWithFacebookButtonPressed(sender: AnyObject) {
        loginButton.enabled = false
        
        if OTMClient.internetConnectionStatusIsConnected() {
            activateActvityView()
            OTMClient.sharedInstance.authenticateWithFacebookFromViewController(self) { (success, results, error) -> Void in
                self.verifyUdacityResults(success, results: results, error: error)
            }
        } else {
            loginButton.enabled = true
            setupAlertView("There is not a internet connection.")
        }
        
    }
    
    //MARK: Helper Functions
    
    func createUdacitySession() {
        loginSession = OTMClient.sharedInstance.createUdacitySessionWithPOST(emailTextField.text!, password: passwordTextField.text!) { (success, results, error) -> Void in
            self.verifyUdacityResults(success, results: results, error: error)
        }
    }
    
    
    func verifyUdacityResults(success: Bool, results: AnyObject!, error: String?) {
        if success {
            if let key = results!["key"] as? String,
                let registered = results!["registered"] as? Bool {
                    if registered {
                        OTMClient.sharedInstance.userId = key
                        self.completeLoginWithKey(OTMClient.sharedInstance.userId!)
                    }
            }
        } else {
            if error! != "cancelled" {
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginButton.enabled = true
                    self.facebookButton.enabled = true
                    self.deactivateActivityView()
                    print(error!)
                    self.setupAlertView(error)
                }
            }
        }
    }

    func completeLoginWithKey(userAccountKey: String) {
        // get user's public data
        
        OTMClient.sharedInstance.getUserData { (success, results, errorString) -> Void in
            if success {
                if let results = results {
                    OTMClient.sharedInstance.firstName = results["first_name"] as? String
                    OTMClient.sharedInstance.lastName = results["last_name"] as? String
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapNavigationController") as! UINavigationController

                        self.deactivateActivityView()

                        self.presentViewController(controller, animated: true) {
                            self.view.alpha = 1.0
                            self.loginButton.enabled = true
                            self.facebookButton.enabled = true
                        }
                        self.view.alpha = 0
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginButton.enabled = true
                    self.facebookButton.enabled = true
                    self.setupAlertView(errorString)
                }
            }
        }
        
    }
    
}


//MARK: Handle textfield
extension LoginViewController: UITextFieldDelegate, UIGestureRecognizerDelegate {
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}





