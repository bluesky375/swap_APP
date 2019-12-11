//
//  UserPhotoViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
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

@available(iOS 13.0, *)
class UserPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    var imagePicked  = 0
    var isFromGallery = false
    var allPhotos = PHFetchResult<PHAsset>()
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var imgMyProfile: UIImageView!
    @IBOutlet weak var collectionViewUserPhoto: UICollectionView!
    @IBOutlet weak var viewMyProfile: UIView!
    @IBOutlet weak var imgDefaultProfile: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let fetchOptions = PHFetchOptions()
        self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        configView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func configView() {
        self.imgDefaultProfile.isHidden = false
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.viewMyProfile.layer.cornerRadius = self.viewMyProfile.frame.height/2
        self.collectionViewUserPhoto.layer.borderWidth = 1.0
        self.collectionViewUserPhoto.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    
    func showAlert() {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .camera)
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
            if imagePicked == 0
            {
                UIImageWriteToSavedPhotosAlbum(chosenImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                self.imgMyProfile.image = chosenImage
                self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
                self.viewMyProfile.layer.cornerRadius = self.viewMyProfile.frame.height/2
                self.imgMyProfile.layer.cornerRadius = self.imgMyProfile.frame.height/2
            }
        } else {
            print("Something went wrong")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
            
        }
    }

    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            let fetchOptions = PHFetchOptions()
            self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            self.collectionViewUserPhoto.reloadData()
        }
        
        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
    func uploadVcard() {
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
        
        if let website : String = strWebsite, let facebook : String = strFacebook, let linkedin : String = strLinkedin, let twitter : String = strTwitter {
            let websiteURL = CNLabeledValue(label:"website", value:website as NSString)
            let facebookURL = CNLabeledValue(label:"facebook", value:facebook as NSString)
            let linkedinURL = CNLabeledValue(label:"linkedin", value:linkedin as NSString)
            let twitterURL = CNLabeledValue(label:"twitter", value:twitter as NSString)
            contact.urlAddresses = [websiteURL, facebookURL, linkedinURL, twitterURL]
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
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyPhotoViewController") as! CompanyPhotoViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            return
                       }
                   })
                }
            }
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
        if self.imgMyProfile.image != nil {
            uploadVcard()
            uploadUserLogo()
        } else {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseSelectPhoto", comment: ""))
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        showAlert()
        imagePicked = (sender as AnyObject).tag
        print("Here is imagePicked: ", imagePicked)
    }
    
}

@available(iOS 13.0, *)
extension UserPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPhotoCollectionCell", for: indexPath) as! UserPhotoCollectionCell
        let asset = allPhotos.object(at: indexPath.row)
        cell.imgUserPhoto.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: cell.imgUserPhoto.frame.size)
        cell.viewUserPhoto.isHidden = !cell.isSelected
        cell.imgCheck.isHidden = !cell.isSelected
        return cell
    }
    
}

@available(iOS 13.0, *)
@available(iOS 13.0, *)
extension UserPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3
        let height = collectionView.frame.height/2
        
        return CGSize(width: width, height: height)
    }
}

@available(iOS 13.0, *)
@available(iOS 13.0, *)
extension UserPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = !cell!.isSelected
        let asset = allPhotos.object(at: indexPath.row)
        imgMyProfile.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: self.imgMyProfile.frame.size)
        viewMyProfile.layer.cornerRadius = viewMyProfile.frame.height/2
        imgMyProfile.layer.cornerRadius = imgMyProfile.frame.height/2
        imgDefaultProfile.isHidden = true
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
//            imgProfileNES = result!
//        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
