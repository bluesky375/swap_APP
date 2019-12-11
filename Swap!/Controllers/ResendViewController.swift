//
//  ResendViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PinCodeTextField
import KVNProgress

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class ResendViewController: UIViewController, PinCodeTextFieldDelegate, UITextFieldDelegate {

    let timeStamp = Date().timeIntervalSince1970
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var viewResend: UIView!
    @IBOutlet weak var txtPinCode: PinCodeTextField!
    @IBOutlet weak var txtResendPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        
    }
    

    func configView() {
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.viewResend.layer.cornerRadius = self.viewResend.frame.height/2
        self.txtPinCode.delegate = self
        self.txtPinCode.keyboardType = .numberPad
        self.txtResendPhone.text = GlobalData.myCard.txtMobileNumberNES
        self.txtPinCode.becomeFirstResponder()
    }

    @IBAction func btnContinueAction(_ sender: Any) {
        
        let verificationID = UserDefaults.group.string(forKey: "authVerificationID")
        let verificationCode = self.txtPinCode.text!
        
        if verificationCode.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterPinCode", comment: ""))
            return
        } else if verificationCode.count < 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterCorrectPinCode", comment: ""))
            return
        } else {
            
            KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode)
            Auth.auth().signIn(with: credential) { (authResult, error) in
              if let error = error {
                KVNProgress.showError(withStatus: error.localizedDescription)
                return
              } else {
                    KVNProgress.showSuccess(withStatus: "LOGIN SUCCESS!")
                    print("authResult: ", authResult as Any)
                    UserDefaults.group.set(Auth.auth().currentUser!.uid, forKey: "ID")
                    GlobalData.myCard.userId = Auth.auth().currentUser!.uid
                    print("ID: ", UserDefaults.group.set(Auth.auth().currentUser!.uid, forKey: "ID") as Any)
                    UserDefaults.group.set(GlobalData.myCard.txtMobileNumberNES, forKey: "mobileNumber")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NameViewController") as! NameViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
        
    @IBAction func brnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResend(_ sender: Any) {
        KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
        PhoneAuthProvider.provider(auth: Auth.auth())
        PhoneAuthProvider.provider().verifyPhoneNumber(self.txtResendPhone.text!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                KVNProgress.showError(withStatus: error.localizedDescription)
                print("Here is error: ", error.localizedDescription)
                return
            } else {
                KVNProgress.showSuccess(withStatus: "Please confirm!")
                UserDefaults.group.set(verificationID, forKey: "authVerificationID")
            }
        }
    }
}
