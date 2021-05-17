//
//  IntroModel.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation

struct MailAuth: Codable {
    var result: Bool
}

struct PhoneAuth: Codable {
    let email: String?
    let result: String
    let myInfo: Owner?
}

struct SignUp: Codable {
    var result: String
}
