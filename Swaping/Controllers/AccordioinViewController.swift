//
//  AccordioinViewController.swift
//  Swaping
//
//  Created by Admin on 1/16/20.
//  Copyright © 2020 Swaping. All rights reserved.
//

import UIKit
import AccordionSwift
import CountryPickerView

class CData {
   var office = ""
   var fax = ""
   var email = ""
   var street = ""
   var city = ""
   var state = ""
   var zip = ""
   var country = ""
   var website = ""
   var facebook = ""
   var linkedin = ""
   var twitter = ""
       
}

class AccordioinViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContinue: UIView!
    typealias ParentCellModel = Parent<GroupCellModel, DetailsCellModel>
    typealias ParentCellConfig = CellViewConfig<ParentCellModel, UITableViewCell>
    typealias ChildCellConfig = CellViewConfig<DetailsCellModel, DetailsTableViewCell>
    
    var dataSourceProvider: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?
    
    var data = CData()
    
    
    let ID = UserDefaults.group.string(forKey: "ID")
    let authVerficationID = UserDefaults.group.string(forKey: "authVerificationID")
    let countryPickerView = CountryPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView.delegate = self
        self.viewContinue.layer.cornerRadius = self.viewContinue.frame.height/2
        configDataSource()
    }
    
    
    @IBAction func btnContinueAction(_ sender: Any) {
        GlobalData.myCard.txtOffice = data.office
        GlobalData.myCard.txtFax = data.fax
        GlobalData.myCard.txtEmail = data.email
        GlobalData.myCard.txtStreet1 = data.street
        GlobalData.myCard.txtCity = data.city
        GlobalData.myCard.txtState = data.state
        GlobalData.myCard.txtZip = data.zip
        GlobalData.myCard.txtCountry = data.country
        GlobalData.myCard.txtWebsite = data.website
        GlobalData.myCard.txtFacebook = data.facebook
        GlobalData.myCard.txtLinkedin = data.linkedin
        GlobalData.myCard.txtTwitter = data.twitter
        
        print("action office: ", data.office)
        
        if authVerficationID != nil, GlobalData.myCard.txtOffice.count != 0  {
            GlobalData.myCard.txtMobileNumberNES = data.office
        }
            let vc = storyboard?.instantiateViewController(withIdentifier: "UserPhotoViewController") as! UserPhotoViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AccordioinViewController {
    
    // MARK: - Methods
    
    /// Configure the data source
    private func configDataSource() {
        
        let groupA = Parent(state: .expanded, item: GroupCellModel(name: "Contacts"),
                            children: [DetailsCellModel(name: "Office", parentId: 1),
                            DetailsCellModel(name: "Fax", parentId: 1),
                            DetailsCellModel(name: "Email", parentId: 1)]
        )
        
        let groupB = Parent(state: .expanded, item: GroupCellModel(name: "Address"),
                            children: [DetailsCellModel(name: "Street", parentId: 2),
                            DetailsCellModel(name: "City", parentId: 2),
                            DetailsCellModel(name: "State", parentId: 2),
                            DetailsCellModel(name: "ZIP", parentId: 2),
                            DetailsCellModel(name: "Country", parentId: 2)]
        )
        
        let groupC = Parent(state: .expanded, item: GroupCellModel(name: "Sites"),
                            children: [DetailsCellModel(name: "Website", parentId: 3),
                                        DetailsCellModel(name: "Facebook", parentId: 3),
                                        DetailsCellModel(name: "Linkedin", parentId: 3),
                                        DetailsCellModel(name: "Twitter", parentId: 3)]
        )
        
        let section0 = Section([groupA, groupB, groupC], headerTitle: nil)
        let dataSource = DataSource(sections: section0)
        
        let parentCellConfig = CellViewConfig<ParentCellModel, UITableViewCell>(
        reuseIdentifier: "GroupCell") { (cell, model, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model?.item.name
            return cell
        }
        
        let childCellConfig = CellViewConfig<DetailsCellModel, DetailsTableViewCell>(
        reuseIdentifier: "DetailsCell") { (cell, item, tableView, indexPath) -> DetailsTableViewCell in
            
            cell.txtOffice.placeholder = item?.name
            
            print("indexpath.row", indexPath.row)
            print("parentId: ", item?.parentId)
            
            if item?.parentId == 1 {
                cell.txtOffice.tag = 1000  + indexPath.row
            } else if item?.parentId == 2 {
                cell.txtOffice.tag = 2000  + indexPath.row
            } else if item?.parentId == 3 {
                cell.txtOffice.tag = 3000  + indexPath.row
            }
            
            cell.txtOffice.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            return cell
        }
        
        let didSelectParentCell = { (tableView: UITableView, indexPath: IndexPath, item: ParentCellModel?) -> Void in
            print("Parent cell \(item!.item.name) tapped")
        }
        
        let didSelectChildCell = { (tableView: UITableView, indexPath: IndexPath, item: DetailsCellModel?) -> Void in
            print("Child cell tapped")
        }
        
        let heightForParentCell = { (tableView: UITableView, indexPath: IndexPath, item: ParentCellModel?) -> CGFloat in
            return 60
        }
        
        let heightForChildCell = { (tableView: UITableView, indexPath: IndexPath, item: DetailsCellModel?) -> CGFloat in
            return 50
        }
        
        let scrollViewDidScroll = { (scrollView: UIScrollView) -> Void in
            print(scrollView.contentOffset)
            
        }
        
        dataSourceProvider = DataSourceProvider(
            dataSource: dataSource,
            parentCellConfig: parentCellConfig,
            childCellConfig: childCellConfig,
            didSelectParentAtIndexPath: didSelectParentCell,
            didSelectChildAtIndexPath: didSelectChildCell,
            heightForParentCellAtIndexPath: heightForParentCell,
            heightForChildCellAtIndexPath: heightForChildCell,
            scrollViewDidScroll: scrollViewDidScroll
        )
        
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
        tableView.delegate = dataSourceProvider?.tableViewDelegate
        tableView.tableFooterView = UIView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let tag = textField.tag
        if tag > 1000, tag < 2000 {
            let index = tag - 1000
            if index == 1 {
                data.office = textField.text!
                print("office", data.office)
            } else if index == 2 {
                data.fax = textField.text!
                print("fax", data.fax)
            } else if index == 3 {
                data.email = textField.text!
                print("email", data.email)
            }
            
        } else if tag > 2000, tag < 3000 {
            let index = tag - 2000
            if index == 5 {
                data.street = textField.text!
            } else if index == 6 {
                data.city = textField.text!
            } else if index == 7 {
                data.state = textField.text!
            } else if index == 8 {
                data.zip = textField.text!
            } else if index == 9 {
//                textField.resignFirstResponder()
//                countryPickerView.showCountriesList(from: self)
                data.country = textField.text!
            }
            
        } else if tag > 3000, tag < 4000 {
            let index = tag - 3000
            if index == 11 {
                data.website = textField.text!
                print("website", data.website)
            } else if index == 12 {
                data.facebook = textField.text!
                print("facebook", data.facebook)
            } else if index == 13 {
                data.linkedin = textField.text!
                print("linkedin", data.linkedin)
            } else if index == 14{
                data.twitter = textField.text!
                print("twitter", data.twitter)
            }
        }
    }
}

@available(iOS 13.0, *)
extension AccordioinViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print("country", country.name)
//        self.txtOffice.text = country.name
        
    }
    
}
