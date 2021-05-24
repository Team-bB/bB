//
//  MyMeetingCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import Foundation
import UIKit

class MyMeetingCell: UITableViewCell {
    @IBOutlet weak var myMeetingStackView: UIStackView!
    @IBOutlet weak var animalShapeImage: UIImageView!
    @IBOutlet weak var numberOfParticipants: UILabel!
    @IBOutlet weak var collegeName: UILabel!
    @IBOutlet weak var tableViewCellLayer: UIView!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var applyCount: [UIButton]!
}
