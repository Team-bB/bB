//
//  ChatVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/16.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
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

class ChatVC: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        
        return formatter
    }()
    
    private let conversationId: String?
    public let otherUserEmail: String
    public var isNewConversation = false
    
    
    private var messages = [Message]()
    
    private var selfSender: Sender? = {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        
        let safeEmail = DatabaseManager.safeEmail(email: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "닉네임") // 닉네임 변경해야함
    }()
    
    init(with email: String, id: String?) {
        self.conversationId = id
        self.otherUserEmail = DatabaseManager.safeEmail(email: email)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id) { [weak self] result in
            switch result {
            case .success(let messages):
                print("✉️✅ 메세지를 가져오는데 성공했습니다 ✉️✅")
                guard !messages.isEmpty else { return }
                
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToBottom()
                    }
                }
                
            case .failure(let error):
                print("✉️❌ 메세지를 가져오는데 실패했습니다 ✉️❌: \(error)")
            }
        }
    }
    
}

extension ChatVC: InputBarAccessoryViewDelegate {
    
    func sendDefaultMesaage() {
        guard let selfSender = self.selfSender, let messageId = createMessageId() else { return }
        
        let mmessage = Message(sender: selfSender,
                               messageId: messageId ,
                               sentDate: Date(),
                               kind: .text("🎊 미팅이 성사 되었습니다!! 🎊\n상대방과 대화를 나눠보세요~\n- 코팅 운영진😃 -"))
        
        // name: 받는 사람 닉네임
        DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage) { [weak self] success in
            
            if success {
                print("📝 메세지 전송 완료. 📝")
                self?.isNewConversation = false
            } else {
                print("⛔️ 메세지 전송 실패 ⛔️")
            }
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: " ").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else { return }
        
        print("Sending: \(text)")
        
        let mmessage = Message(sender: selfSender,
                               messageId: messageId ,
                               sentDate: Date(),
                               kind: .text(text))
        
        // Send Meaage
        if isNewConversation {
            // create convo in database
            
            // name: 받는 사람 닉네임
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage) { [weak self] success in
                
                if success {
                    print("📝 메세지 전송 완료. 📝")
                    self?.isNewConversation = false
                    
                } else {
                    print("⛔️ 메세지 전송 실패 ⛔️")
                }
            }
        } else {
            // append to existing conversation data
            
            guard let conversationId = conversationId else { return }
            let name = self.title ?? "User"
            
            DatabaseManager.shared.sendMessage(to: conversationId, name: name, newMessage: mmessage) { success in
                
                if success {
                    print("📝 메세지 전송 완료. 📝")
                    
                } else {
                    print("⛔️ 메세지 전송 실패 ⛔️")
                }
            }
        }
    }
    
    private func createMessageId() -> String? {
        
        // date, otherUserEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String
        else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(email: currentUserEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        return newIdentifier
    }
}

extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    func currentSender() -> SenderType {
        
        if let sender = selfSender {
            return sender
        }
        
        fatalError("Self Sender is nil")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
