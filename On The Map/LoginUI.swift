//
//  LoginUI.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-31.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//


import UIKit

extension LoginViewController {
    
    func configUI() {
        view.backgroundColor = UIColor.clearColor()

        let colorTop = UIColor(red: 253.0/255.0, green: 110.0/255.0, blue: 36.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 252.0/255.0, green: 171.0/255.0, blue: 50.0/255.0, alpha: 1.0).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
    

    func deactivateActivityView() {
        actvityView.stopAnimating()
        actvityView.hidden = true
    }
    
    func activateActvityView() {
        actvityView.hidden = false
        actvityView.startAnimating()
    }
    
    func setupAlertView(message: String?) {
        
        var errorMessage = ""
        if let message = message {
            errorMessage = message
        } else {
            errorMessage = "Unable to login. Network error."
        }
        
        let alertController = UIAlertController(title: "Could Not Login", message: "\(errorMessage)", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func customizeTextFields() {
        
        emailTextField.layer.cornerRadius = 8.0
        passwordTextField.layer.cornerRadius = 8.0
        loginButton.layer.cornerRadius = 8.0
        facebookButton.layer.cornerRadius = 8.0
        
        let paddingEmail = UIView(frame: CGRectMake(0, 0, 15, emailTextField.frame.height))
        let paddingPassword = UIView(frame: CGRectMake(0, 0, 15, passwordTextField.frame.height))
        emailTextField.leftView = paddingEmail
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftView = paddingPassword
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
    }
    
}