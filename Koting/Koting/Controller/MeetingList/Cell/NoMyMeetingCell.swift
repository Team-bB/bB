//
//  NoMyMeetingCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/17.
//

import Foundation
import UIKit

class NoMyMeetingCell: UITableViewCell {
    
    var buttonCreateMyMeeting: (() -> ())?
    
    @IBOutlet weak var noMyMeeting: UIButton!
    @IBOutlet weak var tableViewCellLayer: UIView!
    @IBAction func noMyMeetingBtnTapped(_ sender: Any) {
        buttonCreateMyMeeting?()
    }
}
