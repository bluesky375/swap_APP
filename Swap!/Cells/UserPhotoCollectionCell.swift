//
//  UserPhotoCollectionCell.swift
//  Swap!
//
//  Created by Catalina on 9/29/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit

class UserPhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var viewUserPhoto: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    override var isSelected: Bool {
        didSet {

            if isSelected {
                imgUserPhoto.layer.borderWidth = 2.0
                imgUserPhoto.layer.borderColor = UIColor.green.cgColor
                viewUserPhoto.isHidden = false
                imgCheck.isHidden = false
                viewUserPhoto.layer.borderWidth = 2.0
                viewUserPhoto.layer.borderColor = UIColor.green.cgColor
                viewUserPhoto.backgroundColor = UIColorFromHex(rgbValue: 0x1f79ce, alpha: 0.5)
                
            } else {
                imgUserPhoto.layer.borderWidth = 0.0
                viewUserPhoto.isHidden = true
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
