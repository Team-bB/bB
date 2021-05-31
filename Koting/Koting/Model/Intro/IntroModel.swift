//
//  IntroModel.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import UIKit

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

enum AnimalFace: String, Codable {
    case dog = "강아지"
    case cat = "고양이"
    case rabbit = "토끼"
    case bear = "곰돌이"
    case dino = "공룡"
    
    func transToImage() -> UIImage? {
        switch self {
        case .dog:
            return UIImage(named: "dog")
        case .cat:
            return UIImage(named: "cat")
        case .rabbit:
            return UIImage(named: "rabbit")
        case .bear:
            return UIImage(named: "bear")
        case .dino:
            return UIImage(named: "dino")
        }
    }
    
    func getAnimalIndex() -> String {
        switch self {
        case .dog:
            return "1"
        case .cat:
            return "2"
        case .rabbit:
            return "3"
        case .bear:
            return "5"
        case .dino:
            return "6"
        }
    }
}
