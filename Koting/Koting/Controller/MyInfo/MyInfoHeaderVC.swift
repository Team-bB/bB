//
//  MyInfoHearderVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/05.
//

import UIKit

class MyInfoHeaderVC: UIViewController {

    @IBOutlet weak var matchPercentLabel: UILabel!
    @IBOutlet weak var myAnimalFaceLabel: UILabel!
    @IBOutlet weak var myAnimalFaceImage: UIImageView!
    @IBOutlet weak var subHeader: UIView!
    @IBOutlet weak var nickName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    
    
    fileprivate func setUI() {
        
        subHeader.layer.cornerRadius = 15
        subHeader.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        subHeader.layer.shadowOpacity = 1.0
        subHeader.layer.shadowOffset = CGSize.zero
        subHeader.layer.shadowRadius = 4
        
        myAnimalFaceImage.layer.cornerRadius = myAnimalFaceImage.frame.size.height / 2
        myAnimalFaceImage.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        myAnimalFaceImage.layer.shadowOpacity = 0.5
        myAnimalFaceImage.layer.shadowOffset = CGSize.zero
        myAnimalFaceImage.layer.shadowRadius = 4
        

        
        myAnimalFaceImage.image = UIImage(named: "dino")
        nickName.text = "닉네임 들어감"
        nickName.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        myAnimalFaceLabel.textColor = .gray

    }
}
