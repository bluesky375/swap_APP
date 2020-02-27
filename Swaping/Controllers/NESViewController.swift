//
//  NESViewController.swift
//  Swaping
//
//  Created by Catalina on 9/29/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import Toast_Swift
import Alamofire
import KVNProgress

@available(iOS 13.0, *)
class NESViewController: UIViewController, UIPopoverPresentationControllerDelegate, CNContactPickerDelegate {

    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    
    var arrCards = [CardModel]()
    var arr = [NSDictionary]()
    
    var isFromGallery : Bool = false
    var imagePicked  = 0
    var dicUserCardData = NSMutableDictionary()
    var activeField: UITextField!
    
    var shareURL = ""
    var index = 0
    var selected = false
    var indexPath : [IndexPath] = []
    var keyArray = [String].self
    
    @IBOutlet weak var collectionViewNES: UICollectionView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func configView() {
        
        collectionViewNES.backgroundColor = UIColor.clear
        arrCards = GlobalData.myCardArray
        self.btnBookmark.isHidden = true
//        self.collectionViewNES.reloadData()
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func shareContactsNew(contact: CNContact) throws {
            
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
        
        try data.write(to: fileURL, options: [.atomicWrite])
    }
    
    func showModal() {
        let modalViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnNewAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "NameViewController") as! NameViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
       
        var keyArray : [String] = []
        if selected {
            let alert = UIAlertController(title: "Remove Card", message: "Do you want really remove your card?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) in
                self.view.makeToastActivity(.center)
                Database.database().reference().child("users").child(self.ID!).observeSingleEvent(of: .value, with: {(snapshot) in
                   if snapshot.exists() {
                       let data = snapshot.value as! [String: Any]
                       for d in data {
                           
                           print(d.key)
                           print(d.value)
                           keyArray.append(d.key)
                       }
                   }
                   
                   print(keyArray)
                   print(self.index)
                   Database.database().reference().child("users").child(self.ID!).child(keyArray[self.index]).removeValue()
                   print(keyArray.startIndex, keyArray.endIndex)
                   self.arrCards.remove(at: self.index)
//                   self.collectionViewNES.reloadData()
                   self.view.hideToastActivity()
               })
           }))
           
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action: UIAlertAction) in
                self.view.hideToastActivity()
            }))
           self.present(alert, animated: true, completion: nil)
            

        } else {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseSelectCard", comment: ""))
        }
    }
    
    @IBAction func btnBookmark(_ sender: Any) {
        
    }
    
    @IBAction func btnShareAction(_ sender: Any) {
        
        if selected {
            let snapshotImageFromMyView = GlobalData.snap
            let cardName = GlobalData.myCard.txtFullNameNES + "\(timeStamp).jpeg"
            let storageRef = Storage.storage().reference(withPath: "Cards").child(ID!).child(cardName)
            
            if let uploadData = snapshotImageFromMyView.jpeg(.lowest) {
               self.view.makeToastActivity(.center)
               storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                  if error != nil {
                      print("Here is Card Uploading error: ", error!.localizedDescription)
                      CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: error!.localizedDescription)
                  } else {
                      storageRef.downloadURL(completion: {
                          url, error in
                          guard url == nil else {
                               self.view.hideToastActivity()
                               print("Here is my Card URL: ", url!)
                               GlobalData.myCard.imgCard = url!.absoluteString
                               print("Here is my Card URL: ", GlobalData.myCard.imgCard)
                               let docData = GlobalData.myCard.getJSON()
                                
                               Database.database().reference().child("cards").child(self.ID!).childByAutoId().setValue(docData) {
                                  (error:Error?, ref:DatabaseReference) in
                                  if let error = error {
                                    print("Data could not be saved: \(error).")
                                  } else {
                                    let htmlFile = Bundle.main.path(forResource: "template", ofType: "html")
                                        let htmlFormat = try? String(contentsOfFile: htmlFile!, encoding: .utf8)
                                        let htmlString = String(format: htmlFormat!, GlobalData.myCard.txtFullNameNES, GlobalData.myCard.txtFullNameNES, GlobalData.myCard.imgCard, GlobalData.myCard.imgCard, GlobalData.myCard.imgCard, GlobalData.myCard.vcardurl)

                                        print("htmlString: ", GlobalData.myCard.txtFullNameNES, htmlString)
                                        APIManager.sharedInstance.createCard(userId: self.ID!, fullName: GlobalData.myCard.txtFullNameNES, htmlString: htmlString, completion: {(result)-> () in
                                            
                                            print("Here is response: ", result)
                                            if result["success"] != nil {
                                                let profileURL = "https://swaptd.appspot.com/profile?userId=" + self.ID!
                                                let dataurl = NSURL(string: profileURL)
                                                
                                                let controller = UIActivityViewController(activityItems: [dataurl!], applicationActivities: nil)
                                                controller.popoverPresentationController?.sourceView = self.view
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                            
                                        })
                                    }
                                    print("Data saved successfully!")
                                  }
                            return
                           }
                      })
                  }
               }
            }
        } else {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseSelectCard", comment: ""))
        }
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "LogOut", message: "Do you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .`default`, handler: { _ in
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                UserDefaults.group.removeObject(forKey: "ID")
                UserDefaults.group.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.group.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension CNContactVCardSerialization {
    class func dataWithImage(contacts: [CNContact]) throws -> Data {
        var text: String = ""
        for contact in contacts {
            let data = try CNContactVCardSerialization.data(with: [contact])
            var str = String(data: data, encoding: .utf8)!
            
            if let imageData = contact.thumbnailImageData {
                let base64 = imageData.base64EncodedString()
                str = str.replacingOccurrences(of: "END:VCARD", with: "PHOTO;ENCODING=b;TYPE=JPEG:\(base64)\nEND:VCARD")
            }
            text = text.appending(str)
        }
        return text.data(using: .utf8)!
    }
}

@available(iOS 13.0, *)
extension NESViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NESCollectionCell", for: indexPath) as! NESCollectionCell
        
        
        let userPhotourl = arrCards[indexPath.row].imgProfileNES
        let userPhotofileUrl = NSURL(string: userPhotourl)
        print("userPhotourl: ", arrCards[indexPath.row].imgProfileNES)
        if let data = try? Data(contentsOf: userPhotofileUrl! as URL)
        {
            cell.imgProfile.image = UIImage(data: data)!
        }
        let companyLogourl = arrCards[indexPath.row].imgCompanyLogoNES
        let companyLogofileUrl = NSURL(string: companyLogourl)
        print("companyLogourl: ", arrCards[indexPath.row].imgCompanyLogoNES)
        print("companyLogourl: ", companyLogourl as Any)
        if let data = try? Data(contentsOf: companyLogofileUrl! as URL)
        {
            cell.imgCompanyLogo.image = UIImage(data: data)!
        }
        cell.lblName.text = arrCards[indexPath.row].txtFullNameNES
        cell.lblTitle.text = arrCards[indexPath.row].txtOccupation
        cell.lblMobileNumber.text = arrCards[indexPath.row].txtMobileNumberNES
        cell.viewCard.backgroundColor = UIColorFromHex(rgbValue: 0x1f79ce, alpha: 1)
        cell.viewHighLight.isHidden = !cell.isSelected
        cell.imgCheck.isHidden = !cell.isSelected
        
//        let userPhotourl = arr[indexPath.row].value?["userPhoto"]
//        let userPhotofileUrl = NSURL(string: userPhotourl)
//        print("userPhotourl: ", arrCards[indexPath.row].imgProfileNES)
//        if let data = try? Data(contentsOf: userPhotofileUrl! as URL)
//        {
//            cell.imgProfile.image = UIImage(data: data)!
//        }
//        let companyLogourl = arrCards[indexPath.row].imgCompanyLogoNES
//        let companyLogofileUrl = NSURL(string: companyLogourl)
//        print("companyLogourl: ", arrCards[indexPath.row].imgCompanyLogoNES)
//        print("companyLogourl: ", companyLogourl as Any)
//        if let data = try? Data(contentsOf: companyLogofileUrl! as URL)
//        {
//            cell.imgCompanyLogo.image = UIImage(data: data)!
//        }
//        cell.lblName.text = arrCards[indexPath.row].txtFullNameNES
//        cell.lblTitle.text = arrCards[indexPath.row].txtOccupation
//        cell.lblMobileNumber.text = arrCards[indexPath.row].txtMobileNumberNES
//        cell.viewCard.backgroundColor = UIColorFromHex(rgbValue: 0x1f79ce, alpha: 1)
//        cell.viewHighLight.isHidden = !cell.isSelected
//        cell.imgCheck.isHidden = !cell.isSelected
        return cell
    }
}

@available(iOS 13.0, *)
extension NESViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionViewNES.frame.width
        let height = CGFloat(140)
        
        return CGSize(width: width, height: height)
    }
}

@available(iOS 13.0, *)
extension NESViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        GlobalData.selectedCard = arrCards[indexPath.row]
//        GlobalData.myCard.imgProfileNES = arrCards[indexPath.row].imgProfileNES
//        GlobalData.myCard.txtLastNameNES = arrCards[indexPath.row].txtLastNameNES
//        GlobalData.myCard.txtFullNameNES = arrCards[indexPath.row].txtFullNameNES
//        GlobalData.myCard.imgCompanyLogoNES = arrCards[indexPath.row].imgCompanyLogoNES
//        GlobalData.myCard.date = arrCards[indexPath.row].date
//        GlobalData.myCard.txtMobileNumberNES = arrCards[indexPath.row].txtFirstNameNES
        GlobalData.myCard = arrCards[indexPath.row]
        self.indexPath = [indexPath]
        self.selected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension UIView{
    var screenshot: UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

