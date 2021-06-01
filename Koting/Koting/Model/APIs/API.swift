//
//  API.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class API {
    
    static let shared = API()

    let BASE_URL = "https://koting.kr"
    
    private init() {}
}

class UserAPI {
    
    static let shared = UserAPI()
    
    var phoneNumber: String?
    var phoneAuthResult: String?
    private init() {}
}


struct User: Codable {
    
}

let tintColor = #colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2078431373, alpha: 1).cgColor
