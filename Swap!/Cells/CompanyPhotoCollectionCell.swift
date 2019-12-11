//
//  CompanyPhotoCollectionCell.swift
//  Swap!
//
//  Created by Catalina on 9/29/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit

class CompanyPhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCompanyPhoto: UIImageView!
    @IBOutlet weak var viewCompanyLogo: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    override var isSelected: Bool {
        didSet {

            if isSelected {
                imgCompanyPhoto.layer.borderWidth = 2.0
                imgCompanyPhoto.layer.borderColor = UIColor.green.cgColor
                viewCompanyLogo.isHidden = false
                imgCheck.isHidden = false
                viewCompanyLogo.layer.borderWidth = 2.0
                viewCompanyLogo.layer.borderColor = UIColor.green.cgColor
                viewCompanyLogo.backgroundColor = UIColorFromHex(rgbValue: 0x1f79ce, alpha: 0.5)
            } else {
                imgCompanyPhoto.layer.borderWidth = 0.0
                viewCompanyLogo.isHidden = true
                imgCheck.isHidden = true
            }
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
