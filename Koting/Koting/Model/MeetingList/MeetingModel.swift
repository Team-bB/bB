//
//  MeetingModel.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/24.
//

import Foundation

struct Info: Codable {
    var sex: String
    var phoneNumber: String
    var college: String
    var major: String
    var age: String
    var height: String
    var mbti: String
    var email: String
}

struct Meeting: Codable {
    var numberOfParticipants: String
    var progressCondition: String
    var userInfo: Info
}

struct APIResponse:Codable {
    var myInfo: Info
    var meetingList: [Meeting]
}

struct CreateMeetingRoomAPIResponse: Codable {
    var meetingList: [Meeting]
}

// 미팅리스트 받아오기
struct FetchMeetingRoomsAPIResponse: Codable {
    var result : String
    var meetingList: [Meeting]
}

var meetingList: [Meeting] = []
var myInfo: Info?
