//
//  ChatVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/16.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Alamofire

class ChatVC: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    private let rightBarButton: UIBarButtonItem = {
        let img = UIImage(systemName: "person.fill.questionmark")
        let button = UIBarButtonItem(image: img,
                                     style: .plain,
                                     target: self, action: #selector(buttonTapped))
        button.tintColor = #colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2117647059, alpha: 1)
        
        return button
    }()
    
    private var messages = [Message]()
    private var conversationId: String?
    public let otherUserEmail: String
    public var isNewConversation = false
    let indicator = CustomIndicator()
   
    
    private var selfSender: Sender? = {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        guard let myNickname = DatabaseManager.shared.getUserInfo()?.nickname else { return nil }
        
        let safeEmail = DatabaseManager.safeEmail(email: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: myNickname) // 닉네임 변경해야함
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
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
    
    @objc func buttonTapped() {
        guard let subString = otherUserEmail.split(separator: "-").first else { return }
        let otherAccountId = String(subString)
        
        indicator.startAnimating(superView: view)
        GetOtherInfoAPI.shared.get(otherAccountId: otherAccountId) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                let otherUserInfo: Owner = finalResult.result
                let vc = UIStoryboard(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "OtherInfoVC") as! OtherInfoVC
                vc.otherUserInfo = otherUserInfo
                vc.otherAccountId = otherAccountId
                vc.conversationId = strongSelf.conversationId
                vc.blockDelegate = self
                
                DispatchQueue.main.async {
                    strongSelf.indicator.stopAnimating()
                    strongSelf.presentPanModal(vc)
                }
                
            case .failure(_):
                strongSelf.indicator.stopAnimating()
                strongSelf.makeAlertBox(title: "오류", message: "에러가 발생했습니다.", text: "확인")
            }
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
                    let alertController = UIAlertController(title: "알림", message: "대화방이 삭제되었습니다.", preferredStyle: .alert)
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
            return UIColor(cgColor: tintColor)
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
        messageInputBar.sendButton.setTitleColor(#colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2117647059, alpha: 1), for: .normal)
        messageInputBar.sendButton.setTitle("전송", for: .normal)
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    
    func sendDefaultMesaage(otherNickname: String) {
        guard let selfSender = self.selfSender, let messageId = createMessageId() else { return }
        
        let mmessage = Message(sender: selfSender,
                               messageId: messageId ,
                               sentDate: Date(),
                               kind: .text("🎊 미팅이 성사 되었습니다!! 🎊\n상대방과 대화를 나눠보세요!!\n⚠️채팅을 삭제하면 영구적으로 삭제됩니다.\n- 코팅 운영진😃 -"))
        
        // name: 받는 사람 닉네임
        DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: otherNickname, firstMessage: mmessage) { [weak self] success in
            
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
                guard let strongSelf = self else { return }
                if success {
                    
                    DatabaseManager.shared.getDeviceToken(otherUserEmail: strongSelf.otherUserEmail) { token in
                        guard let token: String = token else { return }
                        strongSelf.sendNotification(to: token, title: strongSelf.selfSender?.displayName ?? "상대방", text:  "메시지가 도착했어요 💌")
                    
                    }
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
                    DatabaseManager.shared.getDeviceToken(otherUserEmail: strongSelf.otherUserEmail) { token in
                        guard let token: String = token else { return }
                        strongSelf.sendNotification(to: token, title: strongSelf.selfSender?.displayName ?? "상대방", text:  "메시지가 도착했어요 💌")
                    }
                    print("📝 메세지 전송 완료. 📝")
                } else {
                    print("⛔️ 메세지 전송 실패 ⛔️")
                    
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "알림", message: "대화방이 삭제되었습니다.", preferredStyle: .alert)
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
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
       in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

        return .bubbleTail(corner, .curved)
     }
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        guard let message = message as? Message else { return nil }
//        if message.sender.senderId == selfSender?.senderId && message.read == true {
//            return NSAttributedString(string: "읽음", attributes: [.foregroundColor : UIColor.lightGray, .font : UIFont.systemFont(ofSize: 12, weight: .semibold) ])
//        }
//        return nil
//    }
//    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 30
//    }
}

extension ChatVC: BlockDelegate {
    
    func blockUserButtonTapped() {
        guard let conversationId = conversationId else { return }
        indicator.startAnimating(superView: view)
        DatabaseManager.shared.deleteConversation(conversationId: conversationId, other: otherUserEmail) { [weak self] success in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.indicator.stopAnimating()
            }
            
            if success {
                strongSelf.makeAlertBox(title: "완료", message: "상대방을 차단했습니다.", text: "확인") { _ in
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            } else {
                strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인") { _ in
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension ChatVC {
    private func sendNotification(to: String, title: String, text: String) {
        
        let url = "https://fcm.googleapis.com/fcm/send"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("key=\(Key.key)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
    
        //POST로 보낼 정보
        let params: [String:Any] = [
            "notification" : ["title": title, "body": text],
            "to" : to] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            print(response)
        }
    }
    
}
