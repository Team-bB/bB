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
        0 : ["공지사항", "자주 묻는 질문", "문의하기", "앱 정보", "서비스 이용약관", "오픈소스 라이선스"],
        1 : ["개인정보 처리방침", "로그아웃", "회원탈퇴"]
    ]
}

struct Notice: Codable {
    let id: Int
    let title: String
    let content: String
    let date: String
}

struct FaQModel {
    let FaQList : [FaQ] = [FaQ(id: 0,
                               title: "Q. 같은 학과끼리 만날 수 있나요?",
                               content: "아니요. 같은 학과 끼리는 매칭이 되지 않게 했습니다."),
                           FaQ(id: 1,
                               title: "Q. 과팅(소개팅)에 최대 몇 팀까지 신청 가능한가요?",
                               content: "최대 3팀까지 신청 가능합니다."),
                           FaQ(id: 2,
                               title: "Q. 과팅(소개팅)을 신청후 취소할 수 있나요?",
                               content: "아니요. 취소 불가능 합니다."),
                           FaQ(id: 3,
                               title: "Q. 회원정보 수정은 불가능 한가요?",
                               content: "네. 불가능합니다.\n수정이 꼭 필요한 경우에는 문의주세요.")]
}

struct FaQ {
    let id: Int
    let title: String
    let content: String
}

struct GetNoticeAPIResponse: Codable {
    let notice: [Notice]
}

struct WithdrawalAPIResponse: Codable {
    let result: String
}


struct OpenSourceLicenseModel {
    let list = ["Alamofire", "PanModal", "NVActivityIndicatorView", "PagingKit", "MessageKit", "Firebase-ios-sdk"]
    let text =
        """
        Alamofire
        https://github.com/Alamofire/Alamofire
        Copyright (c) 2014-2021 Alamofire Software Foundation
        MIT License

        PanModal
        https://github.com/slackhq/PanModal
        Copyright © 2018 Tiny Speck, Inc.
        MIT License

        NVActivityIndicatorView
        https://github.com/ninjaprox/NVActivityIndicatorView
        Copyright (c) 2016 Vinh Nguyen
        MIT License

        PagingKit
        https://github.com/kazuhiro4949/PagingKit
        Copyright (c) 2017 Kazuhiro Hayashi
        MIT License

        MessageKit
        https://github.com/MessageKit/MessageKit
        Copyright (c) 2017-2020 MessageKit
        MIT License

        Firebase-ios-sdk
        https://github.com/firebase/firebase-ios-sdk
        Copyright © 2015 Google, Inc.
        Apache License 2.0
        """
}
