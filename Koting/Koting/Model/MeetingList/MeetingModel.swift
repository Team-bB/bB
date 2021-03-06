//
//  MeetingModel.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/24.
//

import Foundation
import UIKit

struct Info: Codable {
    let sex: String
    let phoneNumber: String
    let college: String
    let major: String
    let age: String
    let height: String
    let mbti: String
    let email: String
}

struct Owner: Codable {
    let college: String?
    let major: String?
    let sex: String?
    let mbti: String?
    
    let animal_idx: Int?
    let age: Int?
    let height: Int?
    let nickname: String?
}

struct Meeting: Codable {
    let owner: Owner?
    let meeting_id: Int?
    let link: String
    let player: String
    let apply_status: String?
    let date: String?
    let applierCnt: Int?
}
struct Applicant: Codable {
    let college: String?
    let major: String?
    let sex: String?
    let mbti: String?
    
    let animal_idx: Int?
    let age: Int?
    let height: Int?
    let nickname: String?
    let account_id: String
    let apply_id: String
}

struct MyMeeting: Codable {
    let myMeeting: Meeting
    let participant: [Applicant]?
}

struct CreateMeetingRoomAPIResponse: Codable {
    let result: String
}

struct DeleteMeetingRoomAPIResponse: Codable {
    let result: String
}

struct FetchMeetingRoomsAPIResponse: Codable {
    let myMeeting: Meeting?
    let meeting: [Meeting]
}

//struct FetchMeetingRoomsAPIResponse: Codable {
//    let meeting: [Meeting]
//}

struct ApplyMeetingAPIResponse: Codable {
    let result: String
}

struct MyMeetingListAPIResponse: Codable {
    let myCreation: MyMeeting?
    let myApplies: [Meeting]
}

struct DoneMeetingListAPIResponse: Codable {
    let result: [Meeting]?
}

struct AcceptMeetingApplicantAPIResponse: Codable {
    let result: String
    let targetUserEmail: String?
    let nickname: String?
}

struct RejectMeetingApplicantAPIResponse: Codable {
    let result: String
}

struct DeleteCompleteMeetingAPIResponse: Codable {
    let result: String
}

struct ReportAPIResponse: Codable {
    let result: String
}

struct BlockMemberAPIResponse: Codable {
    let result : String
}

enum Participants: Int {
    case oneToOne
    case twoToTwo
    case threeToThree
    case fourToFour
    
    func getNumberOfParticipants() -> String {
        switch self {
        case .oneToOne:
            return "1:1"
        case .twoToTwo:
            return "2:2"
        case .threeToThree:
            return "3:3"
        case .fourToFour:
            return "4:4"
        }
    }
}

struct reportModel {
    let reportReasons = ["욕설 및 비하", "사칭, 사기", "음란물, 불건전한 만남", "정당, 정치인 비하", "기타"]
}
