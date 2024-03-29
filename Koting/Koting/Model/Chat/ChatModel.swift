//
//  ChatModel.swift
//  Koting
//
//  Created by 임정우 on 2021/05/20.
//

import Foundation
import MessageKit

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    public var isRead: Bool
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return  "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}
struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

struct GetOtherInfoAPIResponse: Codable {
    let result: Owner
}
