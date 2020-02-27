//
//  UserPhotoViewController.swift
//  Swaping
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Contacts
import ContactsUI
import Toast_Swift
import YPImagePicker

@available(iOS 13.0, *)
class UserPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    var imagePicked  = 0
    var isFromGallery = false
    var selectedItems = [YPMediaItem]()
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var imgMyProfile: UIImageView!
    @IBOutlet weak var viewMyProfile: UIView!
    @IBOutlet weak var imgDefaultProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
    }
    
    func configView() {
        self.imgMyProfile.layer.masksToBounds = true
        self.imgDefaultProfile.isHidden = false
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.viewMyProfile.layer.cornerRadius = self.viewMyProfile.frame.height/2
        btnCamera.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        
    }
    
    @objc func showResults() {
        if selectedItems.count > 0 {
            let gallery = YPSelectionsGalleryVC(items: selectedItems) { g, _ in
                g.dismiss(animated: true, completion: nil)
            }
            let navC = UINavigationController(rootViewController: gallery)
            self.present(navC, animated: true, completion: nil)
        } else {
            print("No items selected yet.")
        }
    }

        // MARK: - Configuration
    @objc func showPicker() {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.showsCrop = .rectangle(ratio: (16/16))
        config.wordings.libraryTitle = "Photo"
        config.wordings.cameraTitle = "Camera"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        config.library.maxNumberOfItems = 1
        config.gallery.hidesRemoveButton = false
        config.library.preselectedItems = selectedItems
        config.library.defaultMultipleSelection = false
        
        let picker = YPImagePicker(configuration: config)

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.imgMyProfile.image = photo.image
                    self.imgDefaultProfile.isHidden = true
                    self.imgMyProfile.layer.cornerRadius = self.imgMyProfile.frame.height/2
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    
                    let assetURL = video.url
                }
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    func uploadVcard() {
        print("Here")
        var imgProfile = UIImage()
        let strFirstName = GlobalData.myCard.txtFirstNameNES
        let strLastName = GlobalData.myCard.txtLastNameNES
        let strTitle = GlobalData.myCard.txtOccupation
        let strCompany = GlobalData.myCard.txtOrganization
        let strEmail = GlobalData.myCard.txtEmail
        let strStreet1 = GlobalData.myCard.txtStreet1
        let strStreet2 = GlobalData.myCard.txtStreet2
        let strCity = GlobalData.myCard.txtCity
        let strState = GlobalData.myCard.txtState
        let strZip = GlobalData.myCard.txtZip
        let strCountry = GlobalData.myCard.txtCountry
        let strMobileNo = GlobalData.myCard.txtMobileNumberNES
        let strOffice = GlobalData.myCard.txtOffice
        let strFax = GlobalData.myCard.txtFax
        let strWebsite = GlobalData.myCard.txtWebsite
        let strFacebook = GlobalData.myCard.txtFacebook
        let strLinkedin = GlobalData.myCard.txtLinkedin
        let strTwitter = GlobalData.myCard.txtTwitter
        let imgProfileurl = GlobalData.myCard.imgProfileNES
        
        let imgProfileFileUrl = NSURL(string: imgProfileurl)
        if let data = try? Data(contentsOf: imgProfileFileUrl! as URL)
        {
            imgProfile = UIImage(data: data)!
        }
                
        let dicContactDetails = NSMutableDictionary()
        dicContactDetails.setValue(strFirstName, forKey: "User_FirstName")
        dicContactDetails.setValue(strLastName, forKey: "User_LastName")
        dicContactDetails.setValue(strTitle, forKey: "User_Title")
        dicContactDetails.setValue(strCompany, forKey: "User_Company")
        dicContactDetails.setValue(strEmail, forKey: "User_Email")
        dicContactDetails.setValue(strMobileNo, forKey: "User_MobileNo")
        dicContactDetails.setValue(strOffice, forKey: "User_Office")
        dicContactDetails.setValue(strFax, forKey: "User_Fax")
        dicContactDetails.setValue(strWebsite, forKey: "User_Website")
        dicContactDetails.setValue(strFacebook, forKey: "User_Facebook")
        dicContactDetails.setValue(strLinkedin, forKey: "User_Linkedin")
        dicContactDetails.setValue(strTwitter, forKey: "User_Twitter")
        dicContactDetails.setValue(strCountry, forKey: "User_Country")
        dicContactDetails.setValue(strCity, forKey: "User_City")
        dicContactDetails.setValue(strState, forKey: "User_State")
        dicContactDetails.setValue(strStreet1, forKey: "User_Street1")
        dicContactDetails.setValue(strZip, forKey: "User_Zip")
        dicContactDetails.setValue(imgProfile, forKey: "User_Profile")
        let myData = NSKeyedArchiver.archivedData(withRootObject: dicContactDetails)

        let store = CNContactStore()
        var contacts = [CNContact]()
        let contact = CNMutableContact()
        contact.givenName = strFirstName
        contact.familyName = strLastName
        contact.nameSuffix = strTitle
        contact.organizationName = strCompany
        contact.phoneNumbers = [CNLabeledValue(
        label:CNLabelPhoneNumberiPhone,
        value:CNPhoneNumber(stringValue: strMobileNo)), CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: strOffice)), CNLabeledValue(label: CNLabelPhoneNumberHomeFax, value: CNPhoneNumber(stringValue: strFax))]
        
        if let email : String = strEmail {
            let workEmail = CNLabeledValue(label:"work email", value:email as NSString)
            contact.emailAddresses = [workEmail]
        }
        
        if let website : String = strWebsite {
            let websiteURL = CNLabeledValue(label:"website", value:website as NSString)
//            let facebookURL = CNLabeledValue(label:"facebook", value:facebook as NSString)
//            let linkedinURL = CNLabeledValue(label:"linkedin", value:linkedin as NSString)
//            let twitterURL = CNLabeledValue(label:"twitter", value:twitter as NSString)
            contact.urlAddresses = [websiteURL]
        }

        let address = CNMutablePostalAddress()
        address.country = strCountry
        address.city = strCity
        address.state = strState
        address.postalCode = strZip
        address.street = strStreet1
        contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:address)]
        
        contact.imageData = imgProfile.jpeg(.lowest)
        
        let saveRequest = CNSaveRequest()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactNameSuffixKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey, CNContactImageDataAvailableKey, CNContactUrlAddressesKey, CNContactPostalAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        var flag : Bool = false
    
        do {
            try store.enumerateContacts(with: request) {
                (existingcontact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(existingcontact)
                print("existingcontact")
                for phoneNumber in existingcontact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(existingcontact.givenName) \(existingcontact.familyName) \(existingcontact.organizationName) tel:\(localizedLabel) -- \(number), email: \(existingcontact.emailAddresses)")
                        if number.stringValue == strMobileNo {
                            flag = true
                            print("flag", flag)
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
                print("error", error)
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
        print("Here is contact: ", contact)
        guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        let fullname = CNContactFormatter().string(from: contact)!
        
        let fileURL = directoryURL
            .appendingPathComponent(fullname)
            .appendingPathExtension("vcf")
        
        var data = try CNContactVCardSerialization.data(with: [contact])
        
        if contact.thumbnailImageData != nil {
            data = try CNContactVCardSerialization.dataWithImage(contacts: [contact])
            let str = String(data: data, encoding: .utf8)!

            print("contact: \(String(describing: str))")
        } else {
            var text = ""
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
        
        let storageRef = Storage.storage().reference(withPath: "Vcard").child(ID!).child(fullname.appending(".vcf"))
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error == nil {

                storageRef.downloadURL(completion: {
                    url, error in
                    guard url == nil else {
                        print("Here is my Vcard URL: ", url as Any)
                        GlobalData.myCard.vcardurl = url!.absoluteString
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyPhotoViewController") as! CompanyPhotoViewController
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
    
    func uploadUserLogo() {
        
        let imageName = GlobalData.myCard.txtFullNameNES + "\(timeStamp)"
        let storageRef = Storage.storage().reference(withPath: "UsersPhotos").child(ID!).child(imageName)
        if let uploadData = self.imgMyProfile.image!.jpeg(.lowest) {
           self.view.makeToastActivity(.center)
           storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                self.view.hideToastActivity()
                print("Here is UserPhotos Uploading error: ", storageRef)
                print("Here is UserPhotos Uploading error: ", uploadData)
                print("Here is UserPhotos Uploading error: ", error!.localizedDescription)
                CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: error!.localizedDescription)
                   
                } else {
                   storageRef.downloadURL(completion: { url, error in
                       guard url == nil else {
                            self.view.hideToastActivity()
                            print("Here is my UserPhotos URL: ", url!)

                            GlobalData.myCard.imgProfileNES = url!.absoluteString
                            self.uploadVcard()
                            return
                       }
                   })
                }
            }
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
        if self.imgMyProfile.image != nil {
            uploadUserLogo()
            
        } else {
            uploadVcard()
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        
    }
    
}

extension UIImageView{
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            }
            self.image = image
        }
    }
}

