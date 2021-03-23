//
//  API.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation

class API {
    
    static let shared = API()

    let BASE_URL = "http://15.165.143.51"
    
    
    private init() {}
}

class UserAPI {
    
    static let shared = UserAPI()
    
    var mailCheck: Bool = false
    var accountIdCheck: Bool = false
    var phoneNumber: String?
    var phoneAuthResult: String?
    private init() {}
}
