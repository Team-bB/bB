//
//  MeetingListTableViewCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/22.
//

import UIKit

class MeetingListTableViewCell: UITableViewCell {

    @IBOutlet weak var animalShapeImage: UIImageView!
    @IBOutlet weak var collegeName: UILabel!
    @IBOutlet weak var progressCondition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
