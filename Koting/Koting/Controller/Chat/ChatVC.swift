//
//  ChatVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/16.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatVC: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    private var conversationId: String?
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
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .black
        
        hideAvatar()
        
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
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let messages):
                print("✉️✅ 메세지를 가져오는데 성공했습니다 ✉️✅")
                guard !messages.isEmpty else { return }
                
                strongSelf.messages = messages
                
                DispatchQueue.main.async {
                    strongSelf.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom {
                        strongSelf.messagesCollectionView.scrollToLastItem(animated: false)
                    }
                }
                
            case .failure(let error):
                
                print("✉️❌ 메세지를 가져오는데 실패했습니다 ✉️❌: \(error)")
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "알림", message: "상대방이 대화방을 나갔습니다.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "확인", style: .default) { action in
                    
                        strongSelf.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okButton)
                    
                    strongSelf.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
        return .secondarySystemBackground
    }
    
    func hideAvatar() {
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
    }
    
    func setSendButton() {
        messageInputBar.sendButton.setTitleColor(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), for: .normal)
        messageInputBar.sendButton.setTitle("전송", for: .normal)
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    
    func sendDefaultMesaage() {
        guard let selfSender = self.selfSender, let messageId = createMessageId() else { return }
        
        let mmessage = Message(sender: selfSender,
                               messageId: messageId ,
                               sentDate: Date(),
                               kind: .text("🎊 미팅이 성사 되었습니다!! 🎊\n상대방과 대화를 나눠보세요!!\n⚠️채팅을 삭제하면 영구적으로 삭제됩니다.\n- 코팅 운영진😃 -"))
        
        // name: 받는 사람 닉네임
        DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage) { [weak self] success in
            
            guard let strongSelf = self else { return }
            
            if success {
                print("📝 메세지 전송 완료. 📝")
                strongSelf.isNewConversation = false
                let newConversationId = "conversation_\(mmessage.messageId)"
                strongSelf.conversationId = newConversationId
                strongSelf.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                
            } else {
                print("⛔️ 메세지 전송 실패 ⛔️")
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "알림", message: "탈퇴한 회원입니다.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "확인", style: .default) { action in
                    
                        strongSelf.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okButton)
                    
                    strongSelf.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: " ").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else { return }
        
        print("Sending: \(text)")
        messageInputBar.inputTextView.text = nil
        
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
                    let newConversationId = "conversation_\(mmessage.messageId)"
                    self?.conversationId = newConversationId
                    self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                } else {
                    print("⛔️ 메세지 전송 실패 ⛔️")
                }
            }
        } else {
            // append to existing conversation data
            
            guard let conversationId = conversationId else { return }
            let name = self.title ?? "User"
            
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: mmessage) { [weak self] success in
                
                guard let strongSelf = self else { return }
                
                if success {
                    print("📝 메세지 전송 완료. 📝")
                } else {
                    print("⛔️ 메세지 전송 실패 ⛔️")
                    
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "알림", message: "상대방이 대화방을 나갔습니다.", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default) { action in
                        
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(okButton)
                        
                        strongSelf.present(alertController, animated: true, completion: nil)
                    }
                    
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
