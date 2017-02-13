//
//  EvaluatePolicyVC.swift
//  TouchIDDemo
//
//  Created by Kaibo Lu on 2017/2/13.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit
import LocalAuthentication

class EvaluatePolicyVC: UIViewController {

    @IBOutlet weak var label: UILabel!

    @IBAction func authenticationWithBiometrics(_ sender: UIButton) {
        let context = LAContext()
        context.localizedFallbackTitle = "Fall back button"
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = "Cancel button"
        }
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Localized reason for authentication with biometrics", reply: { (success, evaluateError) in
                // NOT in main thread
                DispatchQueue.main.async {
                    if success {
                        self.label.text = "Success"
                        
                        // Do something success
                        
                    } else if let error = evaluateError {
                        self.label.text = error.localizedDescription
                        
                        // Deal with error
                        if let code = LAError.Code(rawValue: (error as NSError).code) {
                            switch code {
                            case .userFallback:
                                print("fall back button clicked")
                            default:
                                break
                            }
                        }
                    }
                }
                
            })
        } else if let error = authError {
            label.text = error.localizedDescription
            
            // Deal with error
        }
    }
    
    @IBAction func authentication(_ sender: UIButton) {
        if #available(iOS 9.0, *) {
            let context = LAContext()
            context.localizedFallbackTitle = "Fall back button"
            if #available(iOS 10.0, *) {
                context.localizedCancelTitle = "Cancel button"
            }
            var authError: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Localized reason for authentication", reply: { (success, evaluateError) in
                    // NOT in main thread
                    DispatchQueue.main.async {
                        if success {
                            self.label.text = "Success"
                            
                            // Do something success
                            
                        } else if let error = evaluateError {
                            self.label.text = error.localizedDescription
                            
                            // When fall back button clicked, user is required to enter PIN. Error code will not be "userFallback"
                            // Deal with error
                        }
                    }
                    
                })
            } else if let error = authError {
                label.text = error.localizedDescription
                
                // Deal with error
            }
        } else {
            let alert = UIAlertController(title: nil, message: "Authentication is available on iOS 9.0 or later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

}

