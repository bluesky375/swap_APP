//
//  CardModel.swift
//  Swap!
//
//  Created by Catalina on 10/4/19.
//  Copyright © 2019 Swap!. All rights reserved.
//

import UIKit

class CardModel: NSObject {
    
    var imgProfileNES = ""
    var imgCompanyLogoNES = ""
    var imgCard = ""
    var txtFirstNameNES = ""
    var txtLastNameNES = ""
    var txtFullNameNES = ""
    var txtTitleNES = ""
    var txtMobileNumberNES = ""
    var txtOccupation = ""
    var txtOrganization = ""
    var txtOffice = ""
    var txtFax = ""
    var txtEmail = ""
    var txtAddress = ""
    var txtStreet1 = ""
    var txtStreet2 = ""
    var txtCity = ""
    var txtState = ""
    var txtZip = ""
    var txtCountry = ""
    var txtWebsite = ""
    var txtFacebook = ""
    var txtLinkedin = ""
    var txtTwitter = ""
    var date = ""
    var vcardurl = ""
    var htmlurl = ""
    var userId = ""
    var cardId = ""
    
    override init() {
        
        super.init()
        
    }
    
    init(dict: [String: Any]) {
        if let val = dict["userPhoto"] as? String              { imgProfileNES = val }
        if let val = dict["companyLogo"] as? String            { imgCompanyLogoNES = val }
        if let val = dict["firstName"] as? String                 { txtFirstNameNES = val }
        if let val = dict["lastName"] as? String                  { txtLastNameNES = val }
        if let val = dict["fullName"] as? String                  { txtFullNameNES = val }
        if let val = dict["phoneNumber"] as? String                { txtMobileNumberNES = val }
        if let val = dict["occupation"] as? String              { txtOccupation = val }
        if let val = dict["organization"] as? String              { txtOrganization = val }
        if let val = dict["office"] as? String                  { txtOffice = val }
        if let val = dict["fax"] as? String                 { txtFax = val }
        if let val = dict["email"] as? String              { txtEmail = val }
        if let val = dict["address"] as? String              { txtAddress = val }
        if let val = dict["street1"] as? String              { txtStreet1 = val }
        if let val = dict["street2"] as? String              { txtStreet2 = val }
        if let val = dict["city"] as? String              { txtCity = val }
        if let val = dict["state"] as? String              { txtState = val }
        if let val = dict["zip"] as? String              { txtZip = val }
        if let val = dict["country"] as? String              { txtCountry = val }
        if let val = dict["website"] as? String              { txtWebsite = val }
        if let val = dict["facebook"] as? String              { txtFacebook = val }
        if let val = dict["linkedin"] as? String              { txtLinkedin = val }
        if let val = dict["twitter"] as? String              { txtTwitter = val }
        if let val = dict["card"] as? String                   { imgCard = val }
        if let val = dict["vcardurl"] as? String                   { vcardurl = val }
        if let val = dict["htmlurl"] as? String                   { htmlurl = val }
        if let val = dict["date"] as? String                   { date = val }
        if let val = dict["userId"] as? String                   { userId = val }
        if let val = dict["cardId"] as? String                   { cardId = val }
    }
    
    func getJSON() -> [String: Any]{
        let body: [String: Any] = [
            "userPhoto": imgProfileNES,
            "companyLogo": imgCompanyLogoNES,
            "firstName": txtFirstNameNES,
            "lastName": txtLastNameNES,
            "fullName": txtFullNameNES,
            "phoneNumber": txtMobileNumberNES,
            "occupation": txtOccupation,
            "organization": txtOrganization,
            "office": txtOffice,
            "fax": txtFax,
            "email": txtEmail,
            "address": txtAddress,
            "street1": txtStreet1,
            "street2": txtStreet2,
            "city": txtCity,
            "state": txtState,
            "zip": txtZip,
            "country": txtCountry,
            "website": txtWebsite,
            "facebook": txtFacebook,
            "linkedin": txtLinkedin,
            "twitter": txtTwitter,
            "card": imgCard,
            "vcardurl": vcardurl,
            "htmlurl": htmlurl,
            "date": Date().timeIntervalSince1970,
            "cardId": cardId,
            "userId": userId
        ]
        
        return body
    }
}
