//
//  DatabaseManager.swift
//  Messenger
//
//  Created by 임정우 on 2021/05/14.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    private let database = Database.database().reference()
    
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
}
extension DatabaseManager {
    
    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        
        database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func uesrExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            
            guard snapshot.value as? String != nil else {
                
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping ((Bool) -> Void)) {
        
        database.child(user.safeEmail).setValue([
            "nick_name": user.nickName,
            "age": user.age,
            "college": user.college,
            "major": user.major,
            "mbti": user.mbti
        ]) { [weak self] error, _ in
            
            guard let strongSelf = self else { return }
            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }
            
            strongSelf.database.child("users").observeSingleEvent(of: .value) { snapshot in
                
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // 기존 Array에 append
                    let newElement = [
                        "nick_name": user.nickName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    strongSelf.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                    
                } else {
                    // 처음 유저 생성
                    let newCollection: [[String: String]] = [
                        [
                            "nick_name": user.nickName,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    strongSelf.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
            }
            completion(true)
        }
        
    }
    
    // 채팅서버에서 상대방을 찾아오는 과정
    func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
 
        database.child("users").observeSingleEvent(of: .value) { snapshot in
   
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFind))
                return
            }
            print(value)
            completion(.success(value))
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFind
        case failedToFetch
    }
}

// MARK: - Sending messages / conversations

extension DatabaseManager {
    
    /// Creates a new conversation with target user email and first message set
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        // ⚠️ UserDefault에서 닉네임도 불러와야함 ⚠️
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentNickname = DatabaseManager.shared.getUserInfo()?.nickname else { return }
        
        let safeEmail = DatabaseManager.safeEmail(email: currentEmail)
//        let otherSafeEmail = DatabaseManager.safeEmail(email: otherUserEmail)
    
        let ref = database.child("\(safeEmail)")

        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatVC.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch firstMessage.kind {
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentNickname,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            // Update recipient conversation entry
            
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
                
                if var conversations = snapshot.value as? [[String: Any]] {
                    // 추가(append)
                    conversations.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                    
                } else {
                    // 새롭게 생성(create)
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            }
            // Update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // 현재 유저의 대화 array가 이미 존재함: append
                
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                
                ref.setValue(userNode) { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                }
                
            } else {
                // 대화 array가 존재 x: create
                userNode["conversations"] = [
                    newConversationData
                ]
                
                ref.setValue(userNode) { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                }
            }
                
        }
        
    }
    
    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) ->Void) {
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatVC.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        switch firstMessage.kind {
        
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String
        else {
            completion(false)
            return
        }
        
        let currentUserEmail = DatabaseManager.safeEmail(email: myEmail)
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        
        print("adding convo: \(conversationID)")
        
        database.child("\(conversationID)").setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Fetches and returns all conversations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        
        database.child("\(email)/conversations").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap { dictonary in
                
                guard let conversationId = dictonary["id"] as? String,
                      let name = dictonary["name"] as? String,
                      let otherUserEmail = dictonary["other_user_email"] as? String,
                      let latestMessage = dictonary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool
                else {
                    return nil
                }
                
                let latestMessageObject = LatestMessage(date: date,
                                                        text: message,
                                                        isRead: isRead)
                
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMessageObject)
            }
            completion(.success(conversations))
        }
        
    }
    
    /// Gets all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap { dictonary in
                guard let name = dictonary["name"] as? String,
                      let isRead = dictonary["is_read"] as? Bool,
                      let messageID = dictonary["id"] as? String,
                      let content = dictonary["content"] as? String,
                      let senderEmail = dictonary["sender_email"] as? String,
                      let type = dictonary["type"] as? String,
                      let dateString = dictonary["date"] as? String,
                      let date = ChatVC.dateFormatter.date(from: dateString)
                else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)
                
                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: .text(content))
            }
            completion(.success(messages))
        }
    }
    
    /// Sends a message with tagrget conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // Add new message to messages
        
        // Update sender
        
        // Update recipient
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentEmail = DatabaseManager.safeEmail(email: myEmail)
        
        database.child("\(conversation)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let strongSelf = self else { return }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageDate = newMessage.sentDate
            let dateString = ChatVC.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch newMessage.kind {
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String
            else {
                completion(false)
                return
            }
            
            let currentUserEmail = DatabaseManager.safeEmail(email: myEmail)
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name
            ]
            
            currentMessages.append(newMessageEntry)
            
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                
                guard error == nil else {
                    completion(false)
                    return
                }
                
                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                    
                    guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
                        completion(false)
                        return
                    }
                    
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message
                    ]
                    
                    var targetConversation: [String: Any]?
                    var position = 0
                    
                    for conversationDict in currentUserConversations {
                        if let currentId = conversationDict["id"] as? String, currentId == conversation {
                            targetConversation = conversationDict
                            break
                        }
                        position += 1
                    }
                    
                    targetConversation?["latest_message"] = updatedValue
                    guard let finalConversation = targetConversation else {
                        completion(false)
                        return
                    }
                    
                    currentUserConversations[position] = finalConversation
                    strongSelf.database.child("\(currentEmail)/conversations").setValue(currentUserConversations) { error, _ in
                        
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        // Update latest message for recipient user
                        
                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                            
                            guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                                completion(false)
                                return
                            }
                            
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            
                            var targetConversation: [String: Any]?
                            var position = 0
                            
                            for conversationDict in otherUserConversations {
                                if let currentId = conversationDict["id"] as? String, currentId == conversation {
                                    targetConversation = conversationDict
                                    break
                                }
                                position += 1
                            }
                            
                            targetConversation?["latest_message"] = updatedValue
                            guard let finalConversation = targetConversation else {
                                completion(false)
                                return
                            }
                            
                            otherUserConversations[position] = finalConversation
                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(otherUserConversations) { error, _ in
                                
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func deleteConversation(conversationId: String, other: String, completion: @escaping (Bool) -> Void) {
        
        database.child(conversationId).removeValue()
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(email: myEmail)
        let safeOtherEmail = DatabaseManager.safeEmail(email: other)
        
        let ref = database.child("\(safeEmail)/conversations")
        let otherRef = database.child("\(safeOtherEmail)/conversations")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                
                for conversation in conversations {
                    if let id = conversation["id"] as? String, id == conversationId {
                        print("🔍 삭제할 대화를 찾았습니다 🔍")
                        break
                    }
                    positionToRemove += 1
                }
                
                conversations.remove(at: positionToRemove)
                
                ref.setValue(conversations) { error, _ in
                    guard error == nil else {
                        completion(false)
                        print("❌ 새로운 대화 Array를 Update 실패 ❌")
                        return
                    }
                    print("✅ 대화를 삭제했습니다 ✅")
                    completion(true)
                }
            }
        }
        
        otherRef.observeSingleEvent(of: .value) { snapshot in
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                
                for conversation in conversations {
                    if let id = conversation["id"] as? String, id == conversationId {
                        print("🔍 삭제할 상대방 대화를 찾았습니다 🔍")
                        break
                    }
                    positionToRemove += 1
                }
                
                conversations.remove(at: positionToRemove)
                
                otherRef.setValue(conversations) { error, _ in
                    guard error == nil else {
                        completion(false)
                        print("❌ 새로운 대화 Array를 Update 실패 ❌")
                        return
                    }
                    print("✅ 대화를 삭제했습니다 ✅")
                    completion(true)
                }
            }
        }
    }
    
    public func withdrawal(completion: @escaping (Bool) -> Void) {
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else { return }
        
        let safeEmail = DatabaseManager.safeEmail(email: myEmail)
        let ref = database.child("\(safeEmail)/conversations")
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let strongSelf = self else { return }
            
            if let conversations = snapshot.value as? [[String: Any]] {
                
                // 나와 연관된 대화 모두 삭제
                for conversation in conversations {
                    
                    guard let id = conversation["id"] as? String,
                          let other = conversation["other_user_email"] as? String else { return }
                    
                    let otherRef = strongSelf.database.child("\(other)/conversations")
                    
                    otherRef.observeSingleEvent(of: .value) { otherSnapshot in
                        if var otherConversations = otherSnapshot.value as? [[String: Any]] {
                            var positionToRemove = 0
                            for conv in otherConversations {
                                if let convId = conv["id"] as? String, convId == id {
                                    break
                                }
                                positionToRemove += 1
                            }
                            otherConversations.remove(at: positionToRemove)
                            
                            otherRef.setValue(otherConversations) { error, _ in
                                guard error == nil else {
                                    print("❌ 새로운 대화 Array를 Update 실패 ❌")
                                    return
                                }
                                print("✅ 상대방 대화를 삭제했습니다 ✅")
                            }
                        }
                    }
                    
                    strongSelf.database.child(id).removeValue()
                }
            }
            
        }
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let strongSelf = self else { return }
            if var users = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for user in users {
                    if let email = user["email"] as? String, email == safeEmail {
                        print("🔍 탈퇴할 내 정보를 찾음 🔍")
                        break
                    }
                    positionToRemove += 1
                }
                
                users.remove(at: positionToRemove)
                strongSelf.database.child("users").setValue(users) { error, _ in
                    guard error == nil else {
                        print("❌ 유저 삭제 실패❌")
                        completion(false)
                        return
                    }
                    print("✅ 유저를 삭제했습니다 ✅")
                }
            }
        }
        database.child(safeEmail).removeValue()
        completion(true)
    }
    
    public func getUserInfo() -> Owner? {
        if let data = UserDefaults.standard.value(forKey:"myInfo") as? Data {
            let infoData = try! PropertyListDecoder().decode(Owner.self, from: data)
            
            return infoData
        }
        return nil
    }
}

struct ChatAppUser {
    let nickName: String
    let emailAddress: String
    let age: String
    let college: String
    let major: String
    let mbti: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
}


