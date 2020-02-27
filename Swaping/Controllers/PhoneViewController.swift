//
//  PhoneViewController.swift
//  Swaping
//
//  Created by Catalina on 9/22/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import KVNProgress
import AuthenticationServices
class PhoneViewController: UIViewController, UITextFieldDelegate, ASAuthorizationControllerDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var viewSigninWithApple: UIView!
//    @IBOutlet weak var btnSigninWithApple: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .light
        if UserDefaults.standard.string(forKey: "authVerificationID") != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.navigationController?.pushViewController(vc, animated: true);
                }
        configView()
        
//        self.btnSigninWithApple.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)

    }
    
    func configView(){
        self.txtPhone.delegate = self
        self.imgLogo.layer.cornerRadius = self.imgLogo.frame.height/2
        self.viewPhone.layer.cornerRadius = self.viewPhone.frame.height/2
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.viewSigninWithApple.layer.cornerRadius = self.viewSigninWithApple.frame.height/2
//        self.btnSigninWithApple.cornerRadius = self.btnSigninWithApple.frame.height/2
    }
    
//    @objc func handleAppleIdRequest() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.performRequests()
//
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//    // Handle error.
//
//
//    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
      let phone = self.txtPhone.text!
    
           if phone.count == 0 {
               CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterPhone", comment: ""))
               return
           }
//           else if !CommonManager.sharedInstance.isValidEmail(testStr: phone) {
//               CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("invalidPhone", comment:""))
//               return
//           }
           else {
//            KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
            //               Auth.auth().signIn(withEmail: email, password: password) { user, error in
            //                   if error != nil, user == nil {
            //                       KVNProgress.showError(withStatus: error?.localizedDescription)
            //                   } else {
            //                       KVNProgress.showSuccess(withStatus: "LOGIN SUCCESS!")
            //                       UserDefaults.standard.set("logined", forKey: "user-id")
            //                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            //                       self.navigationController?.pushViewController(vc, animated: true)
            //                   }
//                Auth.auth().settings!.isAppVerificationDisabledForTesting = true
                PhoneAuthProvider.provider(auth: Auth.auth())
                PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
                  if let error = error {
                    KVNProgress.showError(withStatus: error.localizedDescription)
                    print("Here is error: ", error.localizedDescription)
                    return
                  } else {
                  // Sign in using the verificationID and the code sent to the user
                  // ...
                    KVNProgress.showSuccess(withStatus: "LOGIN SUCCESS!")
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeViewController") as! CodeViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
           }
        }
    
    }
    


