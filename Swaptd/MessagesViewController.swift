//
//  MessagesViewController.swift
//  Swaptd
//
//  Created by admin on 8/23/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import Messages
import Contacts
import ContactsUI
import Toast_Swift
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class MessagesViewController: MSMessagesAppViewController, UIPopoverPresentationControllerDelegate, CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let timeStamp = Date().timeIntervalSince1970
    var arrCards = [CardModel]()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var conversation : MSConversation?
    var savedConversation: MSConversation?
    
    var dicUserCardData = NSMutableDictionary()
    var shareURL = ""
    var selected = false
    
    let ID = UserDefaults.group.string(forKey: "ID")
    
    @IBOutlet weak var collectionViewCardList: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseApp.configure()
        configView()
        
    }
    
    func configView() {
        collectionViewCardList.backgroundColor = UIColor.clear
        print("Here is MessagesViewcontroller: ", ID as Any)
        if ID != nil {
            getCardArray()
//            self.arrCards = UserDefaults.group.array(forKey: "UserCards") as! [CardModel]
//            self.collectionViewCardList.reloadData()
        } else {
            let alert = UIAlertController(title: nil, message: "Open the App!", preferredStyle: .alert)
            alert.view.backgroundColor = UIColor.black
            alert.view.alpha = 0.6
            alert.view.layer.cornerRadius = 15
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) in
                print("Open the door")
                self.openURL(URL(string: "swapapp://NetraTechnosys.Swaptd")!)
            }))
            self.present(alert, animated: true, completion: nil)
       }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
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
            self.collectionViewCardList.reloadData()
            self.view.hideToastActivity()
        }) { (error) in
            self.view.hideToastActivity()
            print(error.localizedDescription)
        }
    }
    
    @objc func openURL(_ url: URL) {
        print("Here is openURL func start: ", url)
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.perform(#selector(openURL(_:)), with: url)
            }
            responder = responder?.next
            print("Here is responder: ", responder as Any)
        }
    }
    
    func ShowAlertEmptyView(Title: String, Massage: String) {
        let alert = UIAlertController(title: Title, message: Massage, preferredStyle:UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        return
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
    
    @IBAction func btnNewAction(_ sender: Any) {
        print("Share button clicked: ")
        UserDefaults.group.removeObject(forKey: "ID")
        self.openURL(URL(string: "swapapp://NetraTechnosys.Swaptd")!)
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
        
        
    }
    
    @IBAction func btnShareAction(_ sender: Any) {
        if selected {
            let snapshotImageFromMyView = GlobalData.snap
            let cardName = GlobalData.myCard.txtFullNameNES + "\(timeStamp).jpeg"
            let storageRef = Storage.storage().reference(withPath: "Cards").child(ID!).child(cardName)
            if let uploadData = snapshotImageFromMyView.jpegData(compressionQuality: 0.0) {
               self.view.makeToastActivity(.center)
               storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("Here is Card Uploading error: ", storageRef)
                        print("Here is Card Uploading error: ", uploadData)
                        print("Here is Card Uploading error: ", error!.localizedDescription)
                        self.view.hideToastActivity()
                        CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: error!.localizedDescription)
                    } else {
                      storageRef.downloadURL(completion: { url, error in
                          guard url == nil else {
                               print("Here is my Card URL: ", url!)
                               GlobalData.myCard.imgCard = url!.absoluteString
                               print("Here is my Card URL: ", GlobalData.myCard.imgCard)
                               let docData = GlobalData.myCard.getJSON()
                                Database.database().reference().child("cards").child(self.ID!).childByAutoId().setValue(docData) { (error:Error?, ref:DatabaseReference) in
                                   if let error = error {
                                       self.view.hideToastActivity()
                                       print("Error adding document: \(error)")
                                   } else {
                                        self.view.hideToastActivity()
                                        let htmlFile = Bundle.main.path(forResource: "template", ofType: "html")
                                        let htmlFormat = try? String(contentsOfFile: htmlFile!, encoding: .utf8)
                                        let htmlString = String(format: htmlFormat!, GlobalData.myCard.txtFullNameNES, GlobalData.myCard.txtFullNameNES, GlobalData.myCard.imgCard, GlobalData.myCard.imgCard, GlobalData.myCard.imgCard, GlobalData.myCard.vcardurl)

                                        print("htmlString: ", GlobalData.myCard.txtFullNameNES, htmlString)
                                        APIManager.sharedInstance.createCard(userId: self.ID!, fullName: GlobalData.myCard.txtFullNameNES, htmlString: htmlString, completion: {(result)-> () in
                                          
                                          print("Here is response: ", result)
                                          if result["success"] != nil {
                                            let profileURL = "https://swaptd.appspot.com/profile?userId=" + self.ID!
                                            let dataurl = NSURL(string: profileURL)
                                            
//                                            self.savedConversation?.insertAttachment(dataurl! as URL, withAlternateFilename: nil, completionHandler: { (error) in
//                                            self.requestPresentationStyle(.compact)

                                            let controller = UIActivityViewController(activityItems: [dataurl!], applicationActivities: nil)
                                            controller.popoverPresentationController?.sourceView = self.view
                                            self.present(controller, animated: true, completion: nil)
//                                            })
                                          }
                                        })
                                   }
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
    
    override func willBecomeActive(with conversation: MSConversation) {
        savedConversation = conversation
        
    }
    
    override func didResignActive(with conversation: MSConversation) {
        
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
       
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
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

extension MessagesViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! CardCollectionCell
        
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
        cell.viewHightLight.isHidden = !cell.isSelected
        cell.imgCheck.isHidden = !cell.isSelected
        return cell
    }
}

extension MessagesViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionViewCardList.frame.width
        let height = CGFloat(140)

        return CGSize(width: width, height: height)
    }
}

extension MessagesViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GlobalData.index = indexPath.row
        GlobalData.selectedCard = arrCards[indexPath.row]
//        GlobalData.myCard.imgProfileNES = arrCards[indexPath.row].imgProfileNES
//        GlobalData.myCard.txtLastNameNES = arrCards[indexPath.row].txtLastNameNES
//        GlobalData.myCard.txtFullNameNES = arrCards[indexPath.row].txtFullNameNES
//        GlobalData.myCard.imgCompanyLogoNES = arrCards[indexPath.row].imgCompanyLogoNES
//        GlobalData.myCard.date = arrCards[indexPath.row].date
//        GlobalData.myCard.txtMobileNumberNES = arrCards[indexPath.row].txtFirstNameNES
        GlobalData.myCard = arrCards[indexPath.row]
        self.selected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension UserDefaults {
  static let group = UserDefaults(suiteName: "group.NetraTechnosys.Swaptd")!
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
