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
        0 : ["공지사항", "앱 정보", "문의하기"],
        1 : ["동물상 재측정", "내 정보 수정", "로그아웃", "회원탈퇴"]
    ]
}
