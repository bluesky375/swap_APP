//
//  MainViewController.swift
//  Swap!
//
//  Created by Catalina on 8/26/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import Messages
import Contacts
import ContactsUI
import FirebaseAuth
import Firebase
import FirebaseStorage

class MainViewController: UIViewController, UITextFieldDelegate,UIPopoverPresentationControllerDelegate, CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewMyProfile: UIView!
    @IBOutlet weak var imgMyProfile: UIImageView!
    
    @IBOutlet weak var viewQuickMyProfile: UIView!
    @IBOutlet weak var imgQuickMyProfile: UIImageView!
    
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var btnEditMyCard: UIButton!
    
    @IBOutlet weak var viewCardFilds: UIView!
    @IBOutlet weak var viewQuickCardFilds: UIView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    
    @IBOutlet weak var txtQuickFirstName: UITextField!
    @IBOutlet weak var txtQuickLastName: UITextField!
    @IBOutlet weak var txtQuickTitle: UITextField!
    @IBOutlet weak var txtQuickCompany: UITextField!
    @IBOutlet weak var txtQuickMobileNo: UITextField!
    @IBOutlet weak var txtQuickEmail: UITextField!
    @IBOutlet weak var txtQuickWebsite: UITextField!
    
    @IBOutlet weak var btnMyCard: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var btnQuickContact: UIButton!
    
    var conversation : MSConversation?
    var savedConversation: MSConversation?
    var isFromGallery : Bool = false
    var imagePicked  = 0
    var dicUserCardData = NSMutableDictionary()
    
    @IBOutlet weak var heightOfInputFields: NSLayoutConstraint!
    @IBOutlet weak var heightOfQuickInputFields: NSLayoutConstraint!
    @IBOutlet weak var yPositionOfButton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()

    }
    func configView() {
        self.viewQuickCardFilds.isHidden = true
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtTitle.delegate = self
        self.txtCompany.delegate = self
        self.txtMobileNo.delegate = self
        self.txtEmail.delegate = self
        self.txtWebsite.delegate = self
        
        self.txtQuickFirstName.delegate = self
        self.txtQuickLastName.delegate = self
        self.txtQuickTitle.delegate = self
        self.txtQuickCompany.delegate = self
        self.txtQuickMobileNo.delegate = self
        self.txtQuickEmail.delegate = self
        self.txtQuickWebsite.delegate = self
        
        self.viewMyProfile.layer.cornerRadius = self.viewMyProfile.frame.size.height / 2
        self.viewMyProfile.layer.borderWidth = 1
        self.viewMyProfile.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.viewMyProfile.layer.shadowRadius = 0
        self.viewEdit.layer.cornerRadius = viewEdit.frame.size.height / 2
        
        self.viewQuickMyProfile.layer.cornerRadius = self.viewQuickMyProfile.frame.size.height / 2
        self.viewQuickMyProfile.layer.borderWidth = 1
        self.viewQuickMyProfile.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.viewQuickMyProfile.layer.shadowRadius = 0
        
        self.btnMyCard.layer.cornerRadius = btnMyCard.frame.size.height / 4
        self.btnContact.layer.cornerRadius = btnContact.frame.size.height / 4
        self.btnQuickContact.layer.cornerRadius = btnQuickContact.frame.size.height / 4
        
        txtFirstName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtFirstName.frame.height))
        txtFirstName.leftViewMode = .always
        
        txtLastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtLastName.frame.height))
        txtLastName.leftViewMode = .always
        
        txtTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtTitle.frame.height))
        txtTitle.leftViewMode = .always
        
        txtCompany.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtLastName.frame.height))
        txtCompany.leftViewMode = .always
        
        txtMobileNo.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtMobileNo.frame.height))
        txtMobileNo.leftViewMode = .always
        
        txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtEmail.frame.height))
        txtEmail.leftViewMode = .always
        
        txtWebsite.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtWebsite.frame.height))
        txtWebsite.leftViewMode = .always
        
        txtQuickFirstName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickFirstName.frame.height))
        txtQuickFirstName.leftViewMode = .always
        
        txtQuickLastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickLastName.frame.height))
        txtQuickLastName.leftViewMode = .always
        
        txtQuickTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickTitle.frame.height))
        txtQuickTitle.leftViewMode = .always
        
        txtQuickCompany.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickLastName.frame.height))
        txtQuickCompany.leftViewMode = .always
        
        txtQuickMobileNo.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickMobileNo.frame.height))
        txtQuickMobileNo.leftViewMode = .always
        
        txtQuickEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickEmail.frame.height))
        txtQuickEmail.leftViewMode = .always
        
        txtQuickWebsite.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtQuickWebsite.frame.height))
        txtQuickWebsite.leftViewMode = .always
    }

    func ShowAlertEmptyView(Title: String, Massage: String)
    {
        let alert = UIAlertController(title: Title, message: Massage, preferredStyle:UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func showAlert() {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .savedPhotosAlbum)
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .savedPhotosAlbum)
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //Final step put this Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let chosenImage = info[.originalImage] as? UIImage {
            isFromGallery = true
            if imagePicked == 1
            {
                //                let bottomImage = chosenImage
                //                let topImage = UIImage(named: "office_R_white")
                //
                //                let size = CGSize(width: 80, height: 80)
                //                UIGraphicsBeginImageContext(size)
                //
                //                let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                //                bottomImage.draw(in: areaSize)
                //                let areaSize1 = CGRect(x: 20, y: 50, width: size.width/2, height: size.height/2)
                //                topImage!.draw(in: areaSize1, blendMode: .normal, alpha: 0.5)
                //
                //                let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                //                UIGraphicsEndImageContext()
                //                self.imgMyProfile.image = newImage
                self.imgMyProfile.image = chosenImage
            } else if imagePicked == 2
            {
                
                self.imgQuickMyProfile.image = chosenImage
            }
        } else {
            print("Something went wrong")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtFirstName {
            self.txtFirstName.resignFirstResponder()
        }
        else if textField == txtLastName
        {
            self.txtLastName.resignFirstResponder()
        }
        else if textField == txtTitle
        {
            self.txtTitle.resignFirstResponder()
        }
        else if textField == txtCompany
        {
            self.txtCompany.resignFirstResponder()
        }
        else if textField == txtMobileNo
        {
            self.txtMobileNo.resignFirstResponder()
        }
        else if textField == txtEmail
        {
            self.txtEmail.resignFirstResponder()
        }
        else if textField == txtWebsite
        {
            self.txtWebsite.resignFirstResponder()
        }
            
            // Quik Contact
        else if textField == txtQuickFirstName
        {
            self.txtQuickFirstName.resignFirstResponder()
        }
        else if textField == txtQuickLastName
        {
            self.txtQuickLastName.resignFirstResponder()
        }
        else if textField == txtQuickTitle
        {
            self.txtQuickTitle.resignFirstResponder()
        }
        else if textField == txtQuickCompany
        {
            self.txtQuickCompany.resignFirstResponder()
        }
        else if textField == txtQuickMobileNo
        {
            self.txtQuickMobileNo.resignFirstResponder()
        }
        else if textField == txtQuickEmail
        {
            self.txtQuickEmail.resignFirstResponder()
        }
        else if textField == txtQuickWebsite
        {
            self.txtQuickWebsite.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnUserProfileAction(_ sender: Any) {
        showAlert()
//        imagePicked = (sender as AnyObject).tag
        imagePicked = 1
        print("Here is imagePIcked: ", imagePicked)
    }

    @IBAction func btnQuickUserProfileAction(_ sender: Any) {
        showAlert()
        imagePicked = (sender as AnyObject).tag
        print("Here is imagePicked: ", imagePicked)
    }
    
    @IBAction func btnMyCardAction(_ sender: Any) {
        self.yPositionOfButton.constant = 150
        viewQuickCardFilds.isHidden = true
        viewCardFilds.isHidden = true
        heightOfInputFields.constant = 0
        heightOfQuickInputFields.constant = 0
        let strFirstName : String = self.txtFirstName.text!
        let strLastName : String = self.txtLastName.text!
        let strTitle : String = self.txtTitle.text!
        let strCompany : String = self.txtCompany.text!
        let strEmail : String = self.txtEmail.text!
        let strMobileNo : String = self.txtMobileNo.text!
        let strWebsite : String = self.txtWebsite.text!
        
        if (self.txtFirstName.text!.isEmpty) {
            ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter First Name!")
        }
        else if (self.txtLastName.text!.isEmpty) {
            ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Last Name!")
        }
        else if (self.txtTitle.text!.isEmpty) {
            ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Title!")
        }
        else if (self.txtMobileNo.text!.isEmpty) {
            ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Mobile Number!")
        }
        else if (self.txtEmail.text!.isEmpty) {
            ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Email Address!")
        }
        else if (self.txtWebsite.text!.isEmpty) {
            ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Website!")
        }
        else {
            let dicContactDetails = NSMutableDictionary()
            dicContactDetails.setValue(strFirstName, forKey: "User_FirstName")
            dicContactDetails.setValue(strLastName, forKey: "User_LastName")
            dicContactDetails.setValue(strTitle, forKey: "User_Title")
            dicContactDetails.setValue(strCompany, forKey: "User_Company")
            dicContactDetails.setValue(strEmail, forKey: "User_Email")
            dicContactDetails.setValue(strMobileNo, forKey: "User_MobileNo")
            dicContactDetails.setValue(strWebsite, forKey: "User_Website")
            dicContactDetails.setValue(imgMyProfile.image, forKey: "User_Profile")
            let myData = NSKeyedArchiver.archivedData(withRootObject: dicContactDetails)
            UserDefaults .standard .set(myData, forKey: "USER_CARD")
            
            UIView.animate(withDuration: 0.8) {
                self.heightOfInputFields.constant = 0
                self.viewQuickCardFilds.isHidden = true
                self.viewCardFilds.isHidden = true
                self.yPositionOfButton.constant = 150
            }
            
            let store = CNContactStore()
            var contacts = [CNContact]()
            let contact = CNMutableContact()
            contact.givenName = strFirstName
            contact.familyName = strLastName
            contact.nameSuffix = strTitle
            contact.organizationName = strCompany
            if let email : String = strEmail {
                let homeEmail = CNLabeledValue(label:"Work Email", value:email as NSString)
                contact.emailAddresses = [homeEmail]
            }
            if let website : String = strWebsite {
                let websiteURL = CNLabeledValue(label:"Website", value:website as NSString)
                contact.urlAddresses = [websiteURL]
            }
            contact.phoneNumbers = [CNLabeledValue(
                label:CNLabelPhoneNumberiPhone,
                value:CNPhoneNumber(stringValue: strMobileNo))]
            if imgMyProfile.image != nil {
//                contact.imageData = imgMyProfile.image!.jpeg(.lowest)
            }
            print(contact.imageData as Any)
            let saveRequest = CNSaveRequest()
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactNameSuffixKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey, CNContactImageDataAvailableKey] as [Any]
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
    }
    @IBAction func btnEditMyCardAction(_ sender: Any) {
        viewQuickCardFilds.isHidden = true
        UIView.animate(withDuration: 0.8) {
            self.heightOfInputFields.constant = 300
            self.yPositionOfButton.constant = 130
            self.viewCardFilds.isHidden = false
        }
        heightOfQuickInputFields.constant = heightOfInputFields.constant
    }
    
    @IBAction func btnContactAction(_ sender: Any) {
        onClickPickContact()
    }
    
    @IBAction func btnQuickContactAction(_ sender: Any) {
        if viewQuickCardFilds.isHidden == false
        {
            if (self.txtQuickFirstName.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter First Name!")
            }
            else if (self.txtQuickLastName.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Last Name!")
            }
            else if (self.txtQuickTitle.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Title!")
            }
            else if (self.txtQuickTitle.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Title!")
            }
            else if (self.txtQuickMobileNo.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Mobile Number!")
            }
            else if (self.txtQuickEmail.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Email Address!")
            }
            else if (self.txtQuickWebsite.text!.isEmpty) {
                ShowAlertEmptyView(Title: "Warning", Massage: "Please Enter Website!")
            }
            else
            {
                let strFirstName : String = self.txtQuickFirstName.text!
                let strLastName : String = self.txtQuickLastName.text!
                let strTitle : String = self.txtQuickTitle.text!
                let strCompany : String = self.txtQuickCompany.text!
                let strEmail : String = self.txtQuickEmail.text!
                let strMobileNo : String = self.txtQuickMobileNo.text!
                let strWebsite : String = self.txtQuickWebsite.text!
                
                //                let dicContactDetails = NSMutableDictionary()
                //                dicContactDetails.setValue(strFirstName, forKey: "User_FirstName")
                //                dicContactDetails.setValue(strLastName, forKey: "User_LastName")
                //                dicContactDetails.setValue(strCompany, forKey: "User_Company")
                //                dicContactDetails.setValue(strEmail, forKey: "User_Email")
                //                dicContactDetails.setValue(strMobileNo, forKey: "User_MobileNo")
                //                dicContactDetails.setValue(strWebsite, forKey: "User_Website")
                //                dicContactDetails.setValue(imgMyProfile.image, forKey: "User_Profile")
                //                let myData = NSKeyedArchiver.archivedData(withRootObject: dicContactDetails)
                //                UserDefaults .standard .set(myData, forKey: "USER_CARD")
                
                UIView.animate(withDuration: 0.8) {
                    //self.heightOfInputFields.constant = 0
                    //self.viewCardFilds.isHidden = true
                    self.heightOfQuickInputFields.constant = 0
                    self.viewQuickCardFilds.isHidden = true
                }
                
                let store = CNContactStore()
                var contacts = [CNContact]()
                let contact = CNMutableContact()
                contact.givenName = strFirstName
                contact.familyName = strLastName
                contact.nameSuffix = strTitle
                contact.organizationName = strCompany
                if let email : String = strEmail {
                    let homeEmail = CNLabeledValue(label:"Work Email", value:email as NSString)
                    contact.emailAddresses = [homeEmail]
                }
                if let website : String = strWebsite {
                    let websiteURL = CNLabeledValue(label:"Website", value:website as NSString)
                    contact.urlAddresses = [websiteURL]
                }
                contact.phoneNumbers = [CNLabeledValue(
                    label:CNLabelPhoneNumberiPhone,
                    value:CNPhoneNumber(stringValue: strMobileNo))]
                if imgQuickMyProfile.image != nil {
//                    contact.imageData = imgQuickMyProfile.image!.jpeg(.lowest)
                    
                }
                let saveRequest = CNSaveRequest()
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactNameSuffixKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey] as [Any]
                let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
                var flag : Bool = false
                do {
                    try store.enumerateContacts(with: request) { (existingcontact, stop) in
                        contacts.append(existingcontact)
                        for phoneNumber in existingcontact.phoneNumbers {
                            
                            if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                                let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                                print("\(existingcontact.givenName) \(existingcontact.familyName) \(existingcontact.organizationName) tel:\(localizedLabel) -- \(number.stringValue), email: \(existingcontact.emailAddresses)")
                                
                                if number.stringValue != strMobileNo {
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
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                do {
                    viewQuickCardFilds.isHidden = true
                    self.yPositionOfButton.constant = 150
                    try shareContactsNew(contact: contact)
                    viewCardFilds.isHidden = true
                }
                catch {
                    
                    print(error.localizedDescription)
                }
            }
        }
        else if viewQuickCardFilds.isHidden == true && viewCardFilds.isHidden == false {
            viewQuickCardFilds.isHidden = false
        }
        else if viewQuickCardFilds.isHidden == true && viewCardFilds.isHidden == true {
        
        }
    }
    
    func onClickPickContact()
    {
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (granted)
            {
                let contactPicker = CNContactPickerViewController()
                contactPicker.delegate = self
                self.present(contactPicker, animated: true, completion: nil)
            }
        })
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty)
    {
        print(contactProperty.contact)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact)
    {
        do {
            try shareContactsNew(contact: contact)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController)
    {
        print("contactPickerDidCancel")
    }
    
    func shareContactsNew(contact: CNContact) throws
    {
        let userID = Auth.auth().currentUser!.uid
        let storage = Storage.storage(url: "gs://swaptd.appspot.com/")
        
        guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        //        var filename = NSUUID().uuidString
        let fullname = CNContactFormatter().string(from: contact)!
        //        if let fullname = CNContactFormatter().string(from: contact) {
        //            filename = fullname.components(separatedBy: " ").joined(separator: "")
        //        }
        
        let fileURL = directoryURL
            .appendingPathComponent(fullname)
            .appendingPathExtension("vcf")
        
        var data = try CNContactVCardSerialization.data(with: [contact])
        
        if contact.thumbnailImageData != nil {
//            data = try CNContactVCardSerialization.dataWithImage(contacts: [contact])
            let str = String(data: data, encoding: .utf8)!
            
            print("contact: \(String(describing: str))")
        } else {
            var text: String = ""
            var str = String(data: data, encoding: .utf8)!
            let img_data = contact.imageData
            if img_data != nil {
                
                let base64_str = img_data!.base64EncodedString()
                str = str.replacingOccurrences(of: "END:VCARD", with: "PHOTO;ENCODING=b;TYPE=JPEG:\(base64_str)\nEND:VCARD")
                print("contact: \(String(describing: str))")
            }
            text = text.appending(str)
            data = text.data(using: .utf8)!
        }
        
        let storageRef = storage.reference(withPath: "Vcard").child(userID).child(fullname.appending(".vcf"))
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error == nil {
                
                storageRef.downloadURL(completion: {
                    url, error in
                    guard url == nil else {
                        print("Here is my Vcard URL: ", url as Any)
                        return
                    }
                    
                    //                    self.saveProfileImage(url: downloadURL)
                })
            } else {
                self.ShowAlertEmptyView(Title: "Warning", Massage: error!.localizedDescription)
            }
        }
        try data.write(to: fileURL, options: [.atomicWrite])
        savedConversation?.insertAttachment(fileURL, withAlternateFilename: nil, completionHandler: { (error) in
            //            self.requestPresentationStyle(.compact)
            let activityViewController = UIActivityViewController (
                activityItems: [fileURL],
                applicationActivities: nil
            )
            
            self.present(activityViewController, animated: true, completion: {})
        })
    }
}
