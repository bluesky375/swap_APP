//
//  RegisterViewController.swift
//  Swap!
//
//  Created by Catalina on 8/25/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import KVNProgress

class RegisterViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var imgRegisterLogo: UIImageView!
    @IBOutlet weak var txtRegisterEmail: UITextField!
    @IBOutlet weak var txtRegisterPassword: UITextField!
    @IBOutlet weak var txtRegisterConfirmPassword: UITextField!
    @IBOutlet weak var btnRegisterRegister: UIButton!
    @IBOutlet weak var btnRegisterLogin: UIButton!
    @IBOutlet weak var viewRegisterEmail: UIView!
    @IBOutlet weak var viewRegisterPassword: UIView!
    @IBOutlet weak var viewRegisterConfirmPassword: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    func configView() {
        self.txtRegisterEmail.delegate = self
        self.txtRegisterPassword.delegate = self
        self.txtRegisterConfirmPassword.delegate = self
        self.imgRegisterLogo.layer.cornerRadius = self.imgRegisterLogo.frame.height/2
        self.viewRegisterEmail.layer.cornerRadius = self.viewRegisterEmail.frame.height/2
        self.viewRegisterPassword.layer.cornerRadius = self.viewRegisterPassword.frame.height/2
        self.viewRegisterConfirmPassword.layer.cornerRadius = self.viewRegisterConfirmPassword.frame.height/2
        self.btnRegisterRegister.layer.cornerRadius = self.btnRegisterRegister.frame.height/2
    }
   
    func ShowAlertEmptyView(Title: String, Massage: String)
    {
        let alert = UIAlertController(title: Title, message: Massage, preferredStyle:UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //Login
        if textField == txtRegisterEmail
        {
            self.txtRegisterEmail.resignFirstResponder()
        }
        else if textField == txtRegisterPassword
        {
            self.txtRegisterPassword.resignFirstResponder()
        }
        else if textField == txtRegisterConfirmPassword
        {
            self.txtRegisterConfirmPassword.resignFirstResponder()
        }

        return true
    }

    @IBAction func btnRegisterRegister(_ sender: Any) {
        let email = self.txtRegisterEmail.text!
        let password = self.txtRegisterPassword.text!
        let confirm = self.txtRegisterConfirmPassword.text!
        
        if email.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterEmail", comment: ""))
            return
        } else if !CommonManager.sharedInstance.isValidEmail(testStr: email) {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("invalidEmail", comment: ""))
            return
        }
        if password.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterPassword", comment: ""))
            return
        } else if password.count < 6 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("passwordMinLength", comment: ""))
            return
        }
        if password != confirm {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("passwordNotMatched", comment: ""))
            return
        }
        KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil || user == nil {
                KVNProgress.showError(withStatus: error?.localizedDescription)
                
            } else {
                Auth.auth().currentUser?.sendEmailVerification(completion: {(error) -> Void in
                    KVNProgress.showSuccess(withStatus: "REGISTER SUCCESS!")
                    UserDefaults.standard.set("logined", forKey: "user-id")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
    }
    @IBAction func btnRegisterLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
