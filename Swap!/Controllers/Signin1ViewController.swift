//
//  Signin1ViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import iOSDropDown
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import KVNProgress
import FlagPhoneNumber

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class Signin1ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    var countryCode = ""
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var txtMobileNumber: FPNTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configView()
    }
    
    func configView() {
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.countryCode = txtMobileNumber.selectedCountry!.phoneCode
        txtMobileNumber.flagButtonSize = CGSize(width: 50, height: 50)

        txtMobileNumber.parentViewController = self
        txtMobileNumber.delegate = self
//        txtMobileNumber.textFieldInputAccessoryView = getCustomTextFieldInputAccessoryView(with: items)
        
        txtMobileNumber.flagButton.isUserInteractionEnabled = true
        txtMobileNumber.becomeFirstResponder()
    }
    
    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()

        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
        if ID == nil {
            PhoneAuthProvider.provider(auth: Auth.auth())
            PhoneAuthProvider.provider().verifyPhoneNumber((self.countryCode + self.txtMobileNumber.text!), uiDelegate: nil) { (verificationID, error) in
              if let error = error {
                KVNProgress.showError(withStatus: error.localizedDescription)
                print("Here is mobile number: ", self.countryCode + self.txtMobileNumber.text!)
                print("Here is error: ", error.localizedDescription)
                return
              } else {
              // Sign in using the verificationID and the code sent to the user
                    KVNProgress.showSuccess(withStatus: "Please confirm!")
                    UserDefaults.group.set(verificationID, forKey: "authVerificationID")
    
                    GlobalData.myCard.txtMobileNumberNES = self.countryCode + self.txtMobileNumber.text!
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResendViewController") as! ResendViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            GlobalData.myCard.txtMobileNumberNES = self.countryCode + self.txtMobileNumber.text!
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NameViewController") as! NameViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

@available(iOS 13.0, *)
extension Signin1ViewController: FPNTextFieldDelegate {

   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print("Here is name and dialCode and code: ", name, dialCode, code) // Output "France", "+33", "FR"
      self.countryCode = dialCode
      print(self.countryCode)
   }

   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {

      if isValid {
         textField.getFormattedPhoneNumber(format: .International)  // Output "+33 6 00 00 00 01"
         textField.getRawPhoneNumber()                               // Output "600000001"
      } else {
      }
   }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
