//
//  LoginViewController.swift
//  Swaping
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swaping. All rights reserved.
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
class LoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    var countryCode = ""
    var arrCards = [CardModel]()
    
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
//        txtMobileNumber.parentViewController = self
        txtMobileNumber.delegate = self
//        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
//        listController.setup(repository: txtMobileNumber.countryRepository)
//        listController.didSelect = { [weak self] country in
//            self!.txtMobileNumber.setFlag(countryCode: country.code)
//        }
////        txtMobileNumber.textFieldInputAccessoryView = getCustomTextFieldInputAccessoryView(with: items)
//        txtMobileNumber.displayMode = .list
        
    
        self.txtMobileNumber.flagButton.isUserInteractionEnabled = false
        self.txtMobileNumber.becomeFirstResponder()
    }
    
    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()

        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }
    
    func getCardArray() {
       self.view.makeToastActivity(.center)
       Database.database().reference().child("users").child(self.ID!).observe(DataEventType.value, with: { (snapshot) in
         // Get user value
           let value = snapshot.value as? [String : Any] ?? [:]
           print("value: ", value as Any)
           
           for val in value {
               print("Here is value: ", val.value)
               let cardData = CardModel.init(dict: val.value as! [String : Any])
               self.arrCards.append(cardData)
           }
           GlobalData.myCardArray = self.arrCards
           self.view.hideToastActivity()
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
           self.navigationController?.pushViewController(vc, animated: true)
       }) { (error) in
           self.view.hideToastActivity()
           print(error.localizedDescription)
       }
   }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        let number = self.countryCode + self.txtMobileNumber.text!
        
        if UserDefaults.group.string(forKey: "mobileNumber") == number {
            
            GlobalData.myCard.txtMobileNumberNES = number
            UserDefaults.group.set("logined", forKey: "logined")
            getCardArray()
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            KVNProgress.showError(withStatus: "Please Enter Correct Number!")
        }
        
//        if ID == nil {
//            PhoneAuthProvider.provider(auth: Auth.auth())
//            PhoneAuthProvider.provider().verifyPhoneNumber((self.countryCode + self.txtMobileNumber.text!), uiDelegate: nil) { (verificationID, error) in
//              if let error = error {
//                KVNProgress.showError(withStatus: error.localizedDescription)
//                print("Here is mobile number: ", self.countryCode + self.txtMobileNumber.text!)
//                print("Here is error: ", error.localizedDescription)
//                return
//              } else {
//              // Sign in using the verificationID and the code sent to the user
//                    KVNProgress.showSuccess(withStatus: "Please confirm!")
//                    UserDefaults.group.set(verificationID, forKey: "authVerificationID")
//
//                    GlobalData.myCard.txtMobileNumberNES = self.countryCode + self.txtMobileNumber.text!
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResendViewController") as! ResendViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        } else {
//
//            GlobalData.myCard.txtMobileNumberNES = self.countryCode + self.txtMobileNumber.text!
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true)
    }
    
    
}

@available(iOS 13.0, *)
extension LoginViewController: FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        
////        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
//        let navigationViewController = UINavigationController(rootViewController: self.listController)
//
//        self.listController.title = "Countries"
//
//        self.present(navigationViewController, animated: true, completion: nil)
    }

   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print("Here is name and dialCode and code: ", name, dialCode, code) // Output "France", "+33", "FR"
      self.countryCode = dialCode
      print(self.countryCode)
   }

   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {

      if isValid {
         textField.getFormattedPhoneNumber(format: .International)  // Output "+33 6 00 00 00 01"
//         textField.getRawPhoneNumber()                               // Output "600000001"
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
