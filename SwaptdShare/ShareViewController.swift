//
//  ShareViewController.swift
//  SwaptdShare
//
//  Created by Catalina on 10/15/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    private var urlString: String?
    private var textString: String?
    var sharedIdentifier = "group.NetraTechnosys.Swaptd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
//        let contentTypeURL = kUTTypeURL as String
//        let contentTypeText = kUTTypeText as String
//
//        for attachment in extensionItem.attachments as! [NSItemProvider] {
//            if attachment.isURL {
//              attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
//                let url = results as! URL?
//                self.urlString = url!.absoluteString
//              })
//            }
//            if attachment.isText {
//              attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil, completionHandler: { (results, error) in
//                let text = results as! String
//                self.textString = text
//                _ = self.isContentValid()
//              })
//            }
//        }
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        
        if urlString != nil || textString != nil {
            if !contentText.isEmpty {
              return true
            }
          }
        return true
    }
	
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        self.dataAttachment()
    }
    
    override func cancel() {
//        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
    }
    
    func dataAttachment() {
//        let content = extensionContext!.inputItems[0] as! NSExtensionItem
//        let contentType = kUTTypeImage as String
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
