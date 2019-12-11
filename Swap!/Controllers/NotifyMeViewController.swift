//
//  NotifyMeViewController.swift
//  Swap!
//
//  Created by Catalina on 9/28/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit

class NotifyMeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    func configView() {
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
