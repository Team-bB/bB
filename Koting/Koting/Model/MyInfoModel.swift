//
//  MyInfoModel.swift
//  Koting
//
//  Created by 임정우 on 2021/05/07.
//

import Foundation

struct MyInfo {
    
    let sections: [String] = [
        "이용안내",
        "계정"
    ]
    
    let list: [Int : [String]] = [
        0 : ["공지사항", "문의하기", "앱 정보"],
        1 : ["로그아웃", "회원탈퇴"]
    ]
}

struct Notice: Codable {
    let id: Int
    let title: String
    let content: String
    let date: String
}

struct GetNoticeAPIResponse: Codable {
    let notice: [Notice]
}

struct WithdrawalAPIResponse: Codable {
    let result: String
}
