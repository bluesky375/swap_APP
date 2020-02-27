//
//  APIManager.swift
//  Swaptd
//
//  Created by Catalina on 11/18/19.
//  Copyright © 2019 Swaping. All rights reserved.
//

import Foundation
//import KVNProgress
import Alamofire

class APIManager {
    static let sharedInstance = APIManager()
    private init() {
        print("NavManager Initialized")
    }
    public func createCard(userId: String, fullName: String, htmlString: String, completion: @escaping (_ result: NSDictionary)->()) {
        let parameters = [
            "userId": userId,
            "fullName": fullName,
            "htmlString": htmlString
        ]
        
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request("https://swaptd.appspot.com/htmls", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as! NSDictionary
                completion(post)
            case .failure(let error):
                print(error.localizedDescription)
//                KVNProgress.showError(withStatus: error.localizedDescription)
            }
        }
        
    }
}

