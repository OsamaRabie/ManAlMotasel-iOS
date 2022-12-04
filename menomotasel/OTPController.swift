//
//  OTPController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 30.11.22.
//

import Foundation
import UIKit

/// Defines the closure to know what happened in the verification process
typealias otpVerificationClosure = (_ otp:String) -> ()

class OTPController: UIViewController {
    
    @IBOutlet var activateBtn: UIButton!
    @IBOutlet var otpTextField: UITextField!
    /// Defines the closure to know what happened in the verification process
    var otpVerificationClosure:otpVerificationClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateBtn.layer.cornerRadius = 15
        activateBtn.clipsToBounds = true
    }
    
    
    @IBAction func verifyAndActivate(_ sender: Any) {
        print("Verify And Activate..")
        
        dismiss(animated: true) { [weak self] in
            self?.otpVerificationClosure?(self?.otpTextField.text ?? "")
        }
#warning("Remove return")
        return
        UserDefaults.standard.set(true, forKey: "isAccountFinished")
        UserDefaults.standard.set(true, forKey: "isRegistrationDone")
    }
    
    @IBAction func closeMe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
