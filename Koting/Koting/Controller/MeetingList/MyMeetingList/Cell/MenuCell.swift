//
//  MenuCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import Foundation
import PagingKit

class MenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override public var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            } else {
                titleLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
    }
}
