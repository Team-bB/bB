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
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userNameLabel.frame = CGRect(x: 10,
                                     y: 10,
                                     width: contentView.bounds.width - 20 - 100 ,
                                     height: (contentView.bounds.height - 20) / 2)
        
        userMessageLabel.frame = CGRect(x: 10,
                                     y: 20,
                                     width: contentView.bounds.width - 20 - 100 ,
                                     height: (contentView.bounds.height - 20) / 2)
    }
    
    public func configure(with model: String) {
        
    }
}
