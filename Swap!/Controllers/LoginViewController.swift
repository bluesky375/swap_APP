//
//  ViewController.swift
//  Swap!
//
//  Created by admin on 8/23/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import KVNProgress

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtLoginEmail: UITextField!
    @IBOutlet weak var txtLoginPassword: UITextField!
    @IBOutlet weak var btnLoginLogin: UIButton!
    @IBOutlet weak var btnLoginRegister: UIButton!
    @IBOutlet weak var viewLoginEmail: UIView!
    @IBOutlet weak var viewLoginPassword: UIView!
    
    var activeField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "user-id") != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.navigationController?.pushViewController(vc, animated: true);
//             self.present(vc, animated: true, completion: nil)
        }
        configView()
    }

    func configView(){
        self.txtLoginEmail.delegate = self
        self.txtLoginPassword.delegate = self
        self.imgLogo.layer.cornerRadius = self.imgLogo.frame.height/2
        self.imgLogo.layer.cornerRadius = self.imgLogo.frame.height/2
        self.viewLoginEmail.layer.cornerRadius = self.viewLoginEmail.frame.height/2
        self.viewLoginPassword.layer.cornerRadius = self.viewLoginPassword.frame.height/2
        self.btnLoginLogin.layer.cornerRadius = self.btnLoginLogin.frame.height/2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtLoginEmail
        {
            self.txtLoginEmail.resignFirstResponder()
        }
        else if textField == txtLoginPassword
        {
            self.txtLoginPassword.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func btnLoginLoginAction(_ sender: Any) {
        let email = self.txtLoginEmail.text!
        let password = self.txtLoginPassword.text!
 
        if email.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterEmail", comment: ""))
            return
        } else if !CommonManager.sharedInstance.isValidEmail(testStr: email) {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("invalidEmail", comment:""))
            return
        }
        if password.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterPassword", comment: ""))
            return
        } else if password.count < 6 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("passwordMinLength", comment: ""))
            return
        }
        KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error != nil, user == nil {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            } else {
                KVNProgress.showSuccess(withStatus: "LOGIN SUCCESS!")
                UserDefaults.standard.set("logined", forKey: "user-id")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnLoginRegisterAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

