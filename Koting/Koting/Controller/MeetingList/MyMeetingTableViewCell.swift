//
//  MyMeetingTableViewCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/02.
//

import UIKit

class MyMeetingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewCellLayer: UIView!
    @IBOutlet weak var collegeName: UILabel!
    @IBOutlet weak var numberOfParticipants: UILabel!
    @IBOutlet weak var animalShapeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
