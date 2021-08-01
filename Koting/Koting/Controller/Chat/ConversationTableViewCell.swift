//
//  ConversationTableViewCell.swift
//  Koting
//
//  Created by 임정우 on 2021/05/18.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationTableViewCell"
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "●"
        label.textColor = .systemRed
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(badgeLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userNameLabel.frame = CGRect(x: 20,
                                     y: 15,
                                     width: contentView.bounds.width - 20 - 100 ,
                                     height: 20)
        
        userMessageLabel.frame = CGRect(x: 20,
                                     y: 35,
                                     width: contentView.bounds.width - 80,
                                     height: (contentView.bounds.height - 20) / 2)
        
        dateLabel.frame = CGRect(x: 40 + userNameLabel.bounds.width,
                                 y: 15,
                                 width: contentView.bounds.width - (20 + userNameLabel.bounds.width) ,
                                 height: 20)
        
        badgeLabel.frame = CGRect(x: 40 + userMessageLabel.bounds.width,
                                     y: contentView.bounds.height / 2,
                                     width: 20,
                                     height: 15)
    }
    
    public func configure(with model: Conversation) {
        
        self.userMessageLabel.text = model.latestMessage.text
        self.userNameLabel.text = model.name
        self.dateLabel.text = String(model.latestMessage.date.split(separator: " ").first!).replacingOccurrences(of: "-", with: "/")
        self.badgeLabel.text = (model.latestMessage.sender != model.otherUserEmail) || (model.latestMessage.sender == model.otherUserEmail && model.latestMessage.isRead) ? "" : "●"
    }
}
