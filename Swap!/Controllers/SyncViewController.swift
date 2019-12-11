//
//  SyncViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Contacts
import ContactsUI

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class SyncViewController: UIViewController {

    let ID = UserDefaults.group.string(forKey: "ID")
    
    @IBOutlet weak var viewEnableContacts: UIView!
    @IBOutlet weak var btnEnableContacts: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        
    }
    
    func configView() {
        self.viewEnableContacts.layer.cornerRadius = self.viewEnableContacts.frame.height/2
        
    }
    
    func uploadVcard() {
        let strFirstName = GlobalData.myCard.txtFirstNameNES
        let strLastName = GlobalData.myCard.txtLastNameNES
        let strTitle = GlobalData.myCard.txtTitleNES
        let strCompany = GlobalData.myCard.txtOccupation
//        let strEmail = self.txtEmail.text!
        let strMobileNo  = GlobalData.myCard.txtMobileNumberNES
//        let strWebsite = self.txtWebsite.text!
//        let strCountry = self.txtCountry.text!
//        let strProvince = self.txtProvince.text!
//        let strPrefecture = self.txtPrefecture.text!
//        let strDistrict = self.txtDistrict.text!
//        let strStreet1 = self.txtStreet1.text!
//        let strPostal = self.txtPostal.text!
                
        let dicContactDetails = NSMutableDictionary()
        dicContactDetails.setValue(strFirstName, forKey: "User_FirstName")
        dicContactDetails.setValue(strLastName, forKey: "User_LastName")
        dicContactDetails.setValue(strTitle, forKey: "User_Title")
        dicContactDetails.setValue(strCompany, forKey: "User_Company")
//        dicContactDetails.setValue(strEmail, forKey: "User_Email")
        dicContactDetails.setValue(strMobileNo, forKey: "User_MobileNo")
//        dicContactDetails.setValue(strWebsite, forKey: "User_Website")
//        dicContactDetails.setValue(strCountry, forKey: "User_Country")
//        dicContactDetails.setValue(strProvince, forKey: "User_Province")
//        dicContactDetails.setValue(strPrefecture, forKey: "User_Prefecture")
//        dicContactDetails.setValue(strDistrict, forKey: "User_District")
//        dicContactDetails.setValue(strStreet1, forKey: "User_Street1")
//        dicContactDetails.setValue(strPostal, forKey: "User_Postal")
//        dicContactDetails.setValue(imgMyProfile.image, forKey: "User_Profile")
        let myData = NSKeyedArchiver.archivedData(withRootObject: dicContactDetails)
    
        let store = CNContactStore()
        var contacts = [CNContact]()
        let contact = CNMutableContact()
        contact.givenName = strFirstName
        contact.familyName = strLastName
        contact.nameSuffix = strTitle
        contact.organizationName = strCompany
//        if let email : String = strEmail {
//            let homeEmail = CNLabeledValue(label:"Work Email", value:email as NSString)
//            contact.emailAddresses = [homeEmail]
//        }
        
//        if let website : String = strWebsite {
//            let websiteURL = CNLabeledValue(label:"Website", value:website as NSString)
//            contact.urlAddresses = [websiteURL]
//        }
//            if let postal : String = strPostal {
//                let postalAddress = CNLabeledValue(label:"Home", value:postal as NSString)
//                contact.postalAddresses = [postalAddress] as! [CNLabeledValue<CNPostalAddress>]
//            }
//        let address = CNMutablePostalAddress()
//        address.country = strCountry
//        address.state = strProvince
//        address.city = strPrefecture
//        address.street = strStreet1
//        address.postalCode = strPostal
//        contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:address)]
        
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue: strMobileNo))]
//        if imgMyProfile.image != nil {
//            contact.imageData = imgMyProfile.image!.jpeg(.lowest)
//        }
        print(contact.imageData as Any)
        let saveRequest = CNSaveRequest()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactNameSuffixKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey, CNContactImageDataAvailableKey, CNContactPostalAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        var flag : Bool = false
    
        do {
            try store.enumerateContacts(with: request) {
                (existingcontact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(existingcontact)
                for phoneNumber in existingcontact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(existingcontact.givenName) \(existingcontact.familyName) \(existingcontact.organizationName) tel:\(localizedLabel) -- \(number.stringValue), email: \(existingcontact.emailAddresses)")
                        if number.stringValue == strMobileNo {
                            flag = true
                            print(flag)
                            break
                        }
                    }
                }
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        if flag != true {
            
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            do {
                try store.execute(saveRequest)
                try shareContactsNew(contact: contact)
                
            } catch {
                print(error)
            }
        } else {
            do {
                try shareContactsNew(contact: contact)
                
            } catch {
                print(error)
            }
        }
    }
        
    func shareContactsNew(contact: CNContact) throws {
                
        guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        let fullname = CNContactFormatter().string(from: contact)!
        
        let fileURL = directoryURL
            .appendingPathComponent(fullname)
            .appendingPathExtension("vcf")
        
        let data = try CNContactVCardSerialization.data(with: [contact])
        
//        if contact.thumbnailImageData != nil {
//            data = try CNContactVCardSerialization.dataWithImage(contacts: [contact])
//            let str = String(data: data, encoding: .utf8)!
//
//            print("contact: \(String(describing: str))")
//        } else {
//            var text = ""
//            var str = String(data: data, encoding: .utf8)!
//            let img_data = contact.imageData
//            if img_data != nil {
//
//                let base64_str = img_data!.base64EncodedString()
//                str = str.replacingOccurrences(of: "END:VCARD", with: "PHOTO;ENCODING=b;TYPE=JPEG:\(base64_str)\nEND:VCARD")
//                print("contact: \(String(describing: str))")
//            }
//            text = text.appending(str)
//            data = text.data(using: .utf8)!
//        }
        
        let storageRef = Storage.storage().reference(withPath: "Vcard").child(ID!).child(fullname.appending(".vcf"))
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error == nil {

                storageRef.downloadURL(completion: {
                    url, error in
                    guard url == nil else {
                        print("Here is my Vcard URL: ", url as Any)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                })
            } else {
//                self.ShowAlertEmptyView(Title: "Warning", Massage: error!.localizedDescription)
            }
        }
        try data.write(to: fileURL, options: [.atomicWrite])
    }
    
    
    @IBAction func btnEnableContacsAction(_ sender: Any) {
        uploadVcard()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
