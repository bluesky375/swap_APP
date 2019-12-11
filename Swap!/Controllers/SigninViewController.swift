//
//  SigninViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit
import FSPagerView
import GetSocial
import GetSocialUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import AuthenticationServices

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class SigninViewController: UIViewController, FSPagerViewDataSource,FSPagerViewDelegate, ASAuthorizationControllerDelegate {
    
    var isSelected:Bool = false
    let ID = UserDefaults.group.string(forKey: "ID")
    let timeStamp = Date().timeIntervalSince1970
    var arrCards = [CardModel]()
    
    fileprivate let imageNames = ["card1.jpeg","card2.jpeg","card3.jpeg","card4.jpeg"]
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.overlap]
//    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear]
    fileprivate var typeIndex = 0 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.pagerView.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .crossFading, .zoomOut, .depth:
                self.pagerView.itemSize = FSPagerView.automaticSize
                self.pagerView.decelerationDistance = 1
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.8, y: 0.9)
                self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .ferrisWheel, .invertedFerrisWheel:
                self.pagerView.itemSize = CGSize(width: 180, height: 140)
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .coverFlow:
                self.pagerView.itemSize = CGSize(width: 220, height: 170)
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
                self.pagerView.decelerationDistance = 1
            }
        }
    }
    let appleIDProvider = ASAuthorizationAppleIDProvider()

    @IBOutlet weak var btnSigninWithApple: ASAuthorizationAppleIDButton!
    @IBOutlet weak var viewSigninWithApple: UIView!
    @IBOutlet weak var viewLoginin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//            self.pagerView.itemSize = FSPagerView.automaticSize
            self.typeIndex = 0
        }
    }
    @IBOutlet weak var btnTroubleLogin: UIButton!
    @IBOutlet weak var viewTroubleLoginDash: UIView!
    
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let index = self.typeIndex
//        self.typeIndex = index // Manually trigger didSet
////        self.pagerView.automaticSlidingInterval = 3.0
//        self.pagerView.isInfinite = true
////        self.pagerView.itemSize = CGSize(width: 300, height: 180)
//        self.pagerView.interitemSpacing = 10
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        self.btnSigninWithApple.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        if ID != nil {
//            getCardArray()
//        } else {
//
//        }
//    }
    
    func configView() {
        
        self.pagerView.interitemSpacing = 10
        self.pagerView.isInfinite = true
        self.pagerView.automaticSlidingInterval = 5.0
//        self.viewSigninWithApple.layer.cornerRadius = self.viewSigninWithApple.frame.height/2
        self.viewSigninWithApple.isHidden = true
        self.viewLoginin.layer.cornerRadius = self.viewLoginin.frame.height/2
        self.btnTroubleLogin.isHidden = true
        self.viewTroubleLoginDash.isHidden = true
        
        if ID != nil {
            self.btnLogin.setTitle("Continue", for: .normal)
            getCardArray()
        } else {
            self.btnLogin.setTitle("Log in", for: .normal)
        }
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
                print("Here is cardData: ", cardData.txtOccupation)
                self.arrCards.append(cardData)
                
            }
            print("arrCards: ", self.arrCards)
            GlobalData.myCardArray = self.arrCards
             self.view.hideToastActivity()
            }) { (error) in
                self.view.hideToastActivity()
                print(error.localizedDescription)
        }
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserPhotoViewController") as! UserPhotoViewController
            self.navigationController?.pushViewController(vc, animated: true)
//            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
//                switch credentialState {
//                   case .authorized:
//                       // The Apple ID credential is valid.
//                       print("authorized")
//                       break
//                   case .revoked:
//                       // The Apple ID credential is revoked.
//                       print("revoked")
//                       break
//                   case .notFound:
//                       // No credential was found, so show the sign-in UI.
//                        break
//                   default:
//                       break
//                }
//            }
        }  else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let username = passwordCredential.user
            let password = passwordCredential.password
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.

    }
    
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
//        self.isSelected = !self.isSelected
//        print("Here is pagerViewSelected status: ", self.isSelected, index)
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        if isSelected == true {
//            cell.layer.borderWidth = 5.0
//            cell.layer.borderColor = UIColor.green.cgColor
//        } else {
//            cell.layer.borderWidth = 0.0
//        }
        print("Here is didSelectItemAt: ", index)
    }
    

    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        print("Here is shouldHIghtlightItemAt: ", index)
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        print("Here is shouldSelectItemAt: ", index)
        return true
    }

    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        
    }

    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        
    }

    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if ID != nil {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserPhotoViewController") as! UserPhotoViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Signin1ViewController") as! Signin1ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSkipAction(_ sender: Any) {
        
        if ID != nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseLogin", comment: ""))
            return
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
//        GetSocial.sendInvite(withChannelId: GetSocial_InviteChannelPluginId_Email, success: {
//            print("Invitation via EMAIL was sent")
//        }, cancel: {
//            print("Invitation via EMAIL was cancelled")
//        }, failure: { error in
//            print("Invitation via EMAIL failed, error: \(error.localizedDescription)")
//        })
        
        let wasShown: Bool = GetSocialUI.createInvitesView().show()
        print("GetSocial Smart Invites UI was shown \(wasShown)")
    }
}
extension UserDefaults {
  static let group = UserDefaults(suiteName: "group.NetraTechnosys.Swaptd")!
}
