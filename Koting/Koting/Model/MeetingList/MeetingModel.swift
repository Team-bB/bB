//
//  MeetingModel.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/24.
//

import Foundation

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
}

struct Meeting: Codable {
    let owner: Owner?
    let meeting_id: Int?
    let link: String
    let player: String
    let apply_status: String?
}
struct Applicant: Codable {
    let college: String?
    let major: String?
    let sex: String?
    let mbti: String?
    
    let animal_idx: Int?
    let age: Int?
    let height: Int?
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
}

struct RejectMeetingApplicantAPIResponse: Codable {
    let result: String
}

struct DeleteCompleteMeetingAPIResponse: Codable {
    let result: String
}
