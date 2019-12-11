//
//  CompanyPhotoViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import Photos
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import Contacts
import ContactsUI

@available(iOS 13.0, *)
class CompanyPhotoViewController: UIViewController {

    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    var allPhotos = PHFetchResult<PHAsset>()
    var arrCards = [CardModel]()
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var imgCompanyPhoto: UIImageView!
    @IBOutlet weak var collectionViewCompanyPhoto: UICollectionView!
    @IBOutlet weak var imgDefaultCompanyLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchOptions = PHFetchOptions()
        self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.collectionViewCompanyPhoto.reloadData()
    }
    
    func configView() {
        self.imgDefaultCompanyLogo.layer.masksToBounds = true
        self.imgDefaultCompanyLogo.layer.cornerRadius = 10
        self.imgCompanyPhoto.layer.masksToBounds = true
        self.imgCompanyPhoto.layer.cornerRadius = 10
        self.imgDefaultCompanyLogo.isHidden = false
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.collectionViewCompanyPhoto.layer.borderWidth = 1.0
        self.collectionViewCompanyPhoto.layer.borderColor = UIColor.gray.cgColor
    }
    
    func getCardArray() {
            self.view.makeToastActivity(.center)
    //        let docRef = Firestore.firestore().collection("users").document(ID!).collection(ID!)
    //        docRef.getDocuments(completion: { (snapshot, error) in
    //            if error == nil {
    //                if (snapshot?.documents.count)! > Int(0) {
    //                    for doc in (snapshot?.documents)! {
    //                        if doc.exists {
    //                            let cardData = CardModel.init(dict: doc.data())
    //                            print("cardData: ", cardData as Any)
    //                            print("doc.data(): ", doc.data() as Any)
    //                            print("companyLogo: ", doc.data()["companyLogo"]! as Any)
    //                            print(cardData.imgCompanyLogoNES as Any)
    //                            print(cardData.txtFirstNameNES)
    //                            self.arrCards.append(cardData)
    //                            GlobalData.myCardArray = self.arrCards
    ////                            UserDefaults.group.set(GlobalData.myCardArray, forKey: "UserCards")
    //                        }
    //                        self.view.hideToastActivity()
    //
    //                    }
    //
    //                } else {
    //                    self.view.hideToastActivity()
    //                    print(error?.localizedDescription as Any)
    //                }
    //            }
    //        })
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
    
    func uploadCompanyLogo() {
    
        let imageName = GlobalData.myCard.txtFullNameNES + "\(timeStamp)"
        let storageRef = Storage.storage().reference(withPath: "CompanyLogos").child(ID!).child(imageName)
        self.view.makeToastActivity(.center)
        if let uploadData = self.imgCompanyPhoto.image?.jpeg(.lowest) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
               if error != nil {
                print("Here is UserPhotos Uploading error: ", error!.localizedDescription)
                   CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: error!.localizedDescription)
               } else {
                   storageRef.downloadURL(completion: {
                       url, error in
                       guard url == nil else {
                            
                            print("Here is my UserPhotos URL: ", url!)
                            GlobalData.myCard.imgCompanyLogoNES = url!.absoluteString
                            print("Here is my UserPhotos URL: ", GlobalData.myCard.imgCompanyLogoNES)
//                            guard let key = Database.database().reference().child("users/\(self.ID!)").childByAutoId().key else { return }
//                            GlobalData.myCard.cardId = key
                            let docData = GlobalData.myCard.getJSON()
                            Database.database().reference().child("users/\(self.ID!)").childByAutoId().setValue(docData) { (error:Error?,ref:DatabaseReference) in
                                if let error = error {
                                  self.view.hideToastActivity()
                                  CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: error.localizedDescription)
                                  print("Data could not be saved: \(error).")
                                } else {
                                    
                                  print("Data successfully Saved!")
                                  self.getCardArray()
                                }
                            }
                           return
                       }
                   })
               }
            }
            
            
        } else {
            
            let docData = GlobalData.myCard.getJSON()
            Database.database().reference().child("users/\(self.ID!)").childByAutoId().setValue(docData) { (error:Error?,ref:DatabaseReference) in
                if let error = error {
                  self.view.hideToastActivity()
                  CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: error.localizedDescription)
                  print("Data could not be saved: \(error).")
                } else {
                    
                  print("Data successfully Saved!")
                  self.getCardArray()
                }
            }
        }
    }
    
    func uploadVcard() {
        var imgProfile = UIImage()
        let strFirstName = GlobalData.myCard.txtFirstNameNES
        let strLastName = GlobalData.myCard.txtLastNameNES
        let strTitle = GlobalData.myCard.txtOccupation
        let strCompany = GlobalData.myCard.txtOrganization
        let strEmail = GlobalData.myCard.txtEmail
        let strMobileNo = GlobalData.myCard.txtMobileNumberNES
        let strOffice = GlobalData.myCard.txtOffice
        let strFax = GlobalData.myCard.txtFax
        let strAddress = GlobalData.myCard.txtAddress
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
        dicContactDetails.setValue(strEmail, forKey: "User_Email")
        dicContactDetails.setValue(strMobileNo, forKey: "User_MobileNo")
        dicContactDetails.setValue(strOffice, forKey: "User_Office")
        dicContactDetails.setValue(strFax, forKey: "User_Fax")
        dicContactDetails.setValue(strWebsite, forKey: "User_Website")
        dicContactDetails.setValue(strWebsite, forKey: "User_Address")
        dicContactDetails.setValue(strWebsite, forKey: "User_Facebook")
        dicContactDetails.setValue(strWebsite, forKey: "User_Linkedin")
        dicContactDetails.setValue(strWebsite, forKey: "User_Twitter")
//        dicContactDetails.setValue(strCountry, forKey: "User_Country")
//        dicContactDetails.setValue(strProvince, forKey: "User_Province")
//        dicContactDetails.setValue(strPrefecture, forKey: "User_Prefecture")
//        dicContactDetails.setValue(strDistrict, forKey: "User_District")
//        dicContactDetails.setValue(strStreet1, forKey: "User_Street1")
//        dicContactDetails.setValue(strPostal, forKey: "User_Postal")
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
        
//        if let website : String = strWebsite {
//            let websiteURL = CNLabeledValue(label:"website", value:website as NSString)
//            contact.urlAddresses = [websiteURL]
//        }
        
        if let website : String = strWebsite, let facebook : String = strFacebook, let linkedin : String = strLinkedin, let twitter : String = strTwitter {
            let websiteURL = CNLabeledValue(label:"website", value:website as NSString)
            let facebookURL = CNLabeledValue(label:"facebook", value:facebook as NSString)
            let linkedinURL = CNLabeledValue(label:"linkedin", value:linkedin as NSString)
            let twitterURL = CNLabeledValue(label:"twitter", value:twitter as NSString)
            contact.urlAddresses = [websiteURL, facebookURL, linkedinURL, twitterURL]
        }
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
        
        contact.imageData = imgProfile.jpeg(.lowest)
        
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
                        print("\(existingcontact.givenName) \(existingcontact.familyName) \(existingcontact.organizationName) tel:\(localizedLabel) -- \(number), email: \(existingcontact.emailAddresses)")
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
                        return
                    }
                })
            } else {
//                self.ShowAlertEmptyView(Title: "Warning", Massage: error!.localizedDescription)
            }
        }
        try data.write(to: fileURL, options: [.atomicWrite])
    }

    
    @IBAction func btnContinueAction(_ sender: Any) {
//        uploadVcard()
        uploadCompanyLogo()
        
    }
    
    
    @IBAction func btnSkipAction(_ sender: Any) {
        self.view.makeToastActivity(.center)
//        uploadVcard()
        getCardArray()
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

@available(iOS 13.0, *)
extension CompanyPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyPhotoCollectionCell", for: indexPath) as! CompanyPhotoCollectionCell
        let asset = allPhotos.object(at: indexPath.row)
        cell.imgCompanyPhoto.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: cell.imgCompanyPhoto.frame.size)
        cell.viewCompanyLogo.isHidden = !cell.isSelected
        cell.imgCheck.isHidden = !cell.isSelected
        return cell
    }
}

@available(iOS 13.0, *)
@available(iOS 13.0, *)
extension CompanyPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = collectionView.frame.width/3
        let height = collectionView.frame.height/2
        
        return CGSize(width: width, height: height)
    }
}

@available(iOS 13.0, *)
@available(iOS 13.0, *)
extension CompanyPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = allPhotos.object(at: indexPath.row)
        imgCompanyPhoto.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: self.imgCompanyPhoto.frame.size)
        imgDefaultCompanyLogo.isHidden = true
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
//            imgCompanyLogoNES = result!
//        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
}
