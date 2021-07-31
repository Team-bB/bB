//
//  ConversationModel.swift
//  Koting
//
//  Created by 임정우 on 2021/05/20.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
    let sender: String
}
