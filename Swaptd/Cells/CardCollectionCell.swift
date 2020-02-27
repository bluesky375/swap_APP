//
//  CardCollectionCell.swift
//  Swaptd
//
//  Created by Catalina on 11/1/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit

class CardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var viewHightLight: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    
    var isInEditingMode: Bool = false {
        didSet {
//            checkmarkLabel.isHidden = !isInEditingMode

        }
    }

    override var isSelected: Bool {
        didSet {
//            if isInEditingMode {
////                checkmarkLabel.text = isSelected ? "✓" : ""
//
//            }
            if isSelected {
                GlobalData.snap = viewCard.screenshot
                viewCard.layer.borderWidth = 2.0
                viewCard.layer.borderColor = UIColor.green.cgColor
                viewHightLight.isHidden = false
                imgCheck.isHidden = false
                viewHightLight.layer.borderWidth = 2.0
                viewHightLight.layer.borderColor = UIColor.green.cgColor
                viewHightLight.backgroundColor = UIColorFromHex(rgbValue: 0x1f79ce, alpha: 0.5)
            } else {
                viewCard.layer.borderWidth = 0.0
                viewHightLight.isHidden = true
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
