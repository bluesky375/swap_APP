//
//  RecoveryViewController.swift
//  Swaping
//
//  Created by Admin on 12/19/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit

class RecoveryViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    func configView() {
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
    }
}
