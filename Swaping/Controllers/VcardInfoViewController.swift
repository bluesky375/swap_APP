//
//  VcardInfoViewController.swift
//  Swaping
//
//  Created by Catalina on 12/4/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CountryPickerView
import AccordionSwift

@available(iOS 13.0, *)
class VcardInfoViewController: UIViewController, UITextFieldDelegate{
    
    let ID = UserDefaults.group.string(forKey: "ID")
    let authVerficationID = UserDefaults.group.string(forKey: "authVerificationID")
    let countryPickerView = CountryPickerView()
    
    @IBOutlet weak var txtOffice: UITextField!
    @IBOutlet weak var txtFax: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtStreet1: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtLinkedin: UITextField!
    @IBOutlet weak var txtTwitter: UITextField!
    @IBOutlet weak var txtFacebook: UITextField!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    func configView() {
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.txtOffice.setLeftPaddingPoints(10)
        self.txtFax.setLeftPaddingPoints(10)
        self.txtEmail.setLeftPaddingPoints(10)
        self.txtStreet1.setLeftPaddingPoints(10)
        self.txtCity.setLeftPaddingPoints(10)
        self.txtState.setLeftPaddingPoints(10)
        self.txtZip.setLeftPaddingPoints(10)
        self.txtCountry.setLeftPaddingPoints(10)
        self.txtWebsite.setLeftPaddingPoints(10)
        self.txtFacebook.setLeftPaddingPoints(10)
        self.txtLinkedin.setLeftPaddingPoints(10)
        self.txtTwitter.setLeftPaddingPoints(10)
        txtCountry.delegate = self
        countryPickerView.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        countryPickerView.showCountriesList(from: self)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
        GlobalData.myCard.txtOffice = self.txtOffice.text!
        GlobalData.myCard.txtFax = self.txtFax.text!
        GlobalData.myCard.txtEmail = self.txtEmail.text!
        GlobalData.myCard.txtStreet1 = self.txtStreet1.text!
        GlobalData.myCard.txtCity = self.txtCity.text!
        GlobalData.myCard.txtState = self.txtState.text!
        GlobalData.myCard.txtZip = self.txtZip.text!
        GlobalData.myCard.txtCountry = self.txtCountry.text!
        GlobalData.myCard.txtWebsite = self.txtWebsite.text!
        GlobalData.myCard.txtFacebook = self.txtFacebook.text!
        GlobalData.myCard.txtLinkedin = self.txtLinkedin.text!
        GlobalData.myCard.txtTwitter = self.txtTwitter.text!
        
        if authVerficationID != nil, GlobalData.myCard.txtOffice.count != 0  {
            GlobalData.myCard.txtMobileNumberNES = self.txtOffice.text!
        }
            let vc = storyboard?.instantiateViewController(withIdentifier: "UserPhotoViewController") as! UserPhotoViewController
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
@available(iOS 13.0, *)
extension VcardInfoViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print("country", country.name)
        self.txtCountry.text = country.name
        
    }
    
}

