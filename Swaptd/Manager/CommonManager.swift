//
//  CommonManager.swift
//  Swaptd
//
//  Created by Catalina on 11/18/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import Foundation
import UIKit
class CommonManager {
    static let sharedInstance = CommonManager()
    private init() {
        print("NavManager Initialized")
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showAlert(viewCtrl: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        viewCtrl.present(alert, animated: true, completion: nil)
    }
    
    func sharePlace(id: String, vc: UIViewController, state: @escaping (_ result: Bool)->()) {
        
        let string = "Take a look at this awesone place \nhttps://qualimoments.com/share/place/\(id)"
        let objectsToShare = [string]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = vc.view
        vc.present(activityVC, animated: true, completion: nil)
    }
    
    public func getDate(timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp)/1000)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func isValidPassword(testStr: String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
        return passwordTest.evaluate(with: testStr)
    }
}

