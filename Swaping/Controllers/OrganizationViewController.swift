//
//  OrganizationViewController.swift
//  Swaping
//
//  Created by Catalina on 12/1/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class OrganizationViewController: UIViewController {

    @IBOutlet weak var txtOrganization: UITextField!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    func configView() {
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        self.txtOrganization.setLeftPaddingPoints(10)
    }

    @IBAction func btnContinueAction(_ sender: Any) {
        GlobalData.myCard.txtOrganization = self.txtOrganization.text!
        let vc = storyboard?.instantiateViewController(withIdentifier: "VcardInfoViewController") as! VcardInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
