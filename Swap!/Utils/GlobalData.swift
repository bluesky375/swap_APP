//
//  GlobalData.swift
//  Swap!
//
//  Created by Catalina on 11/11/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import Foundation
import UIKit

class GlobalData {
    static var myCard = CardModel()
    static var myCardArray = [CardModel]()
    static var myArray = [NSDictionary]()
    static var snap = UIImage()
    static var index = 0
    static var selectedCard = CardModel()
    
    static let path = Bundle.main.path(forResource: "Config", ofType: "plist")
    static let config = NSDictionary(contentsOfFile: path!)
    static let baseURLString = config!["serverUrl"] as! String
}
