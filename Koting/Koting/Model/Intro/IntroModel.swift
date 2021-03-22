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
    var result: String
}

struct SignUp: Codable {
    var result: String
}
