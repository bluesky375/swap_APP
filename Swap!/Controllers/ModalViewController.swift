//
//  ModalViewController.swift
//  Swap!
//
//  Created by Catalina on 11/22/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var card = CardModel()
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCardEdit: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    func configView() {
        
        card = GlobalData.selectedCard
        self.viewCardEdit.backgroundColor = UIColorFromHex(rgbValue: 0x1f79ce, alpha: 1)
        self.viewDelete.layer.cornerRadius = self.viewDelete.frame.height/2
        self.viewEdit.layer.cornerRadius = self.viewEdit.frame.height/2
        self.viewCancel.layer.cornerRadius = self.viewCancel.frame.height/2
        view.backgroundColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5)
        self.viewContainer.backgroundColor = UIColor.clear
        view.isOpaque = true
        
        let userPhotourl = card.imgProfileNES
        let userPhotofileUrl = NSURL(string: userPhotourl)
        print("userPhotourl: ", card.imgProfileNES)
        if let data = try? Data(contentsOf: userPhotofileUrl! as URL)
        {
            imgProfile.image = UIImage(data: data)!
        }
        let companyLogourl = card.imgCompanyLogoNES
        let companyLogofileUrl = NSURL(string: companyLogourl)
        print("companyLogourl: ", card.imgCompanyLogoNES)
        print("companyLogourl: ", companyLogourl as Any)
        if let data = try? Data(contentsOf: companyLogofileUrl! as URL)
        {
            imgCompanyLogo.image = UIImage(data: data)!
        }
        txtName.text = card.txtFullNameNES
        txtTitle.text = card.txtOccupation
        txtMobileNumber.text = card.txtMobileNumberNES
    }
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        
    }
    
    
    @IBAction func btnEditAction(_ sender: Any) {
        
        
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
