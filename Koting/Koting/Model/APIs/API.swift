//
//  API.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation

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

