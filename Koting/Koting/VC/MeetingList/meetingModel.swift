//
//  meetingModel.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/22.
//

import Foundation


struct MeetingInfo: Codable {
    let sex: String
    let college: String
    let major: String
    let age: String
    let height: String
    let mbti: String
    let progressCondition: String
    let numberOfParticipants: String
}

struct APIResponse: Codable {
    let MeetingList: [MeetingInfo]
}
