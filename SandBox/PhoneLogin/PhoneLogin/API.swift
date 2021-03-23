//
//  API.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/12.
//

import Foundation

class API {
    static let shared = API()
    var phoneNumber: String?
    var accountId: String?
    var whereToGo: String?
    let BASE_URL = "http://15.165.143.51"
    
    private init() {
        
    }
}
