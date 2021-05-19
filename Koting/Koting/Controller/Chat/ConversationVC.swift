//
//  ConversationVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/16.
//

import UIKit

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
}


class ConversationVC: UIViewController {
    
    private let indicator = CustomIndicator()
    
    private var conversations = [Conversation]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ConversationTableViewCell.self,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        table.isHidden = true
        
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
        
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        
        setupTableView()
        fetchConversations()
        startListeningForConversations()
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        tableView.frame = view.bounds
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations() {
        
        tableView.isHidden = false
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
                
                guard !conversations.isEmpty else { return }
                self?.conversations = conversations
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.indicator.stopAnimating()
                }
                
            case .failure(let error):
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
        vc.sendDefaultMesaage()
        vc.title = name
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
        
        let nextVC = ChatVC(with: model.otherUserEmail, id: model.id)
        nextVC.title = model.name
        nextVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
