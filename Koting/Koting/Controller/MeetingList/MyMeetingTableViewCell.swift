//
//  MyMeetingTableViewCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/02.
//

import UIKit
import ExpyTableView

class MyMeetingTableViewCell: UITableViewCell, ExpyTableViewHeaderCell {
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
            print("MyHeaderCell - state : \(state) / cellReuse:\(cellReuse)")
            switch state {
            case .willExpand:
                print("펼쳐질 예정")
            case .willCollapse:
                print("접힐 예정")
            case .didExpand:
                print("펼쳐짐")
            case .didCollapse:
                print("접혀짐")
            }
        }
    }
    
    
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
