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
    @IBOutlet weak var measureButton: UIButton!
    @IBOutlet weak var myAnimalFaceImage: UIImageView!
    @IBOutlet weak var subHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    @IBAction func measureButtonTapped(_ sender: Any) {
    }
    
    fileprivate func setUI() {
        
        subHeader.layer.cornerRadius = 15
        subHeader.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        subHeader.layer.shadowOpacity = 1.0
        subHeader.layer.shadowOffset = CGSize.zero
        subHeader.layer.shadowRadius = 4
        
        myAnimalFaceImage.layer.cornerRadius = myAnimalFaceImage.frame.size.height / 2
        myAnimalFaceImage.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        myAnimalFaceImage.layer.shadowOpacity = 1.0
        myAnimalFaceImage.layer.shadowOffset = CGSize.zero
        myAnimalFaceImage.layer.shadowRadius = 4
        

        
        myAnimalFaceImage.image = UIImage(named: "dino")
        
        measureButton.layer.cornerRadius = 5
        measureButton.setEnable(enable: true, backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        measureButton.setTitleColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), for: .normal)
        
        myAnimalFaceLabel.textColor = .gray

    }
}
