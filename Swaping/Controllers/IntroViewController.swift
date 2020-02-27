//
//  IntroViewController.swift
//  Swaping
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swaping. All rights reserved.
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
import SafariServices


@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class IntroViewController: UIViewController, FSPagerViewDataSource,FSPagerViewDelegate, ASAuthorizationControllerDelegate {
    
    var isSelected:Bool = false
    let ID = UserDefaults.group.string(forKey: "ID")
    let Logined = UserDefaults.group.string(forKey: "logined")
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


    @IBOutlet weak var viewLoginin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNewAccount: UIButton!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//            self.pagerView.itemSize = FSPagerView.automaticSize
            self.typeIndex = 0
        }
    }
    @IBOutlet weak var btnTroubleLogin: UIButton!
    @IBOutlet weak var viewTroubleLoginDash: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    
    
    
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
        
    }

    
    func configView() {
        
        self.pagerView.interitemSpacing = 10
        self.pagerView.isInfinite = true
        self.pagerView.automaticSlidingInterval = 5.0
        self.viewLoginin.layer.cornerRadius = self.viewLoginin.frame.height/2
//        self.viewLoginin.layer.borderWidth = 1
//        self.viewLoginin.layer.borderColor = UIColor.systemPink.cgColor
        self.btnSkip.isHidden = true
        if ID != nil {
            self.btnLogin.setTitle("Continue", for: .normal)
        } else {
            self.btnLogin.setTitle("LOG IN WITH PHONE NUMBER", for: .normal)
        }
    }
    
    func getCardArray() {
        
        self.view.makeToastActivity(.center)
        Database.database().reference().child("users").child(self.ID!).observe(DataEventType.value, with: { (snapshot) in
          // Get user value
            let value = snapshot.value as? [String : Any] ?? [:]
            print("value: ", value as Any)
            let date = value["date"] as? String ?? ""
            print("date", date)
            
            for val in value {
                print("Here is value: ", val.value)
                
                let cardData = CardModel.init(dict: val.value as! [String : Any])
                print("Here is cardData: ", cardData.date)
                self.arrCards.append(cardData)
                
            }
            print("arrCards: ", self.arrCards)
            GlobalData.myCardArray = self.arrCards
            self.view.hideToastActivity()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NESViewController") as! NESViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
                self.view.hideToastActivity()
                print(error.localizedDescription)
        }
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
    
    @IBAction func btnNewAccount(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if ID != nil {
            getCardArray()

        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
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
    
    @IBAction func btnTroubleLoginAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecoveryViewController") as! RecoveryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        
        if let url = URL(string: "https://swaptd.com/swapprivacy/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func btnTermsAction(_ sender: Any) {
        
        if let url = URL(string: "https://swaptd.com/swapprivacy/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
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
