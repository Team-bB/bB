//
//  ConversationVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/16.
//

import UIKit

class ConversationVC: UIViewController {
    
    private let indicator = CustomIndicator()
    
    private var conversations = [Conversation]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ConversationTableViewCell.self,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        table.tableFooterView = UIView()
        table.isHidden = true
        table.tableFooterView?.isHidden = true
        
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅이 없습니다!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        
        setupTableView()
        startListeningForConversations()
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        tableView.frame = view.bounds
        noConversationsLabel.frame = CGRect(x: 10,
                                            y: (view.bounds.height - 100) / 2,
                                            width: view.bounds.width - 20,
                                            height: 100)
    }
    
    private func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        lbl.text = "   채팅"
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = lbl
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func startListeningForConversations() {
        indicator.startAnimating(superView: view)
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        
        print("----- 💬 채팅목록 Fetching... -----")
        DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] result in
            switch result {
            case .success(let conversations):
                print("💬✅ 채팅목록 불러오기 성공 💬✅")
                
                guard !conversations.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.tableView.tableFooterView?.isHidden = true
                    self?.noConversationsLabel.isHidden = false
                    return
                }
                
                self?.noConversationsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.tableFooterView?.isHidden = false
                self?.conversations = conversations
                self?.conversations.sort(by: {$0.latestMessage.date > $1.latestMessage.date})
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.indicator.stopAnimating()
                }
                
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noConversationsLabel.isHidden = false
                print("💬❌ 채팅목록 불러기 실패 💬❌, 오류 : \(error)")
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                }
            }
        }
    }
    
    static func createNewConversation(name: String, email: String) {
        
        let vc = ChatVC(with: email, id: nil)
        vc.isNewConversation = true
        vc.title = name
        vc.sendDefaultMesaage(otherNickname: name)
    }
}

extension ConversationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        let model = conversations[indexPath.row]
        
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversations[indexPath.row]
        openConversation(model)
    }
    
    func openConversation(_ model: Conversation) {
        let nextVC = ChatVC(with: model.otherUserEmail, id: model.id)
        nextVC.title = model.name
        nextVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "알림", message: "채팅방이 영구적으로 삭제됩니다.\n삭제 하시겠습니까?", preferredStyle: .alert)
            let removeButton = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                
                guard let strongSelf = self else { return }
                let conversationId = strongSelf.conversations[indexPath.row].id
                let otherUserEmail = strongSelf.conversations[indexPath.row].otherUserEmail
                tableView.beginUpdates()
                
                DatabaseManager.shared.deleteConversation(conversationId: conversationId, other: otherUserEmail) { success in
                    
                    if success {
                        print("💬✅ 대화방 삭제완료")
                    }
                }
            }
            let okButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertController.addAction(removeButton)
            alertController.addAction(okButton)
            
            present(alertController, animated: true, completion: nil)
            // begin delete
            
            tableView.endUpdates()
        }
    }
}
