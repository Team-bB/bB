//
//  MyMeetingCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import Foundation
import UIKit

class MyMeetingCell: UITableViewCell {
    
    var buttonCreateMyMeeting: (() -> ())?
    
    @IBOutlet weak var myMeetingStackView: UIStackView!
    @IBOutlet weak var noMyMeeting: UIButton!
    @IBOutlet weak var animalShapeImage: UIImageView!
    @IBOutlet weak var numberOfParticipants: UILabel!
    @IBOutlet weak var collegeName: UILabel!
    @IBOutlet weak var tableViewCellLayer: UIView!
    @IBAction func noMyMeetingBtnTapped(_ sender: Any) {
        buttonCreateMyMeeting?()
    }
}
