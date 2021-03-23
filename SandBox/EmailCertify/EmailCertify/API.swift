//
//  API.swift
//  EmailCertify
//
//  Created by 홍화형 on 2021/03/15.
//

import Foundation

class API {
    static let shared = API()
    
    let phoneNumberURL = "http://15.165.143.51/auth"
    let BASE_URL = "http://15.165.143.51"
    /////////////////////////////////////////////////////////
    var phoneNumber = ""

    private init() {
    }
}
