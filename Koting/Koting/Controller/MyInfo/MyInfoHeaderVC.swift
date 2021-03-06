//
//  MyInfoHearderVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/05.
//

import UIKit

class MyInfoHeaderVC: UIViewController {


    @IBOutlet weak var myAnimalFaceImage: UIImageView!
    
    @IBOutlet weak var myAnimalFace: UILabel!
    @IBOutlet weak var myMajorAndMBTI: UILabel!
    @IBOutlet weak var myNickname: UILabel!
    @IBOutlet weak var subHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    
    
    fileprivate func setUI() {
        
        guard let userInfo = getUserInfo() else { return }
        
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
        

        // 고칠준비
        myAnimalFaceImage.image = UIImage(named: transImage(index: userInfo.animal_idx ?? 1))
        myAnimalFace.text = transString(index: userInfo.animal_idx ?? 1)
        
        myNickname.text = userInfo.nickname
        myMajorAndMBTI.text = "\(userInfo.major!) | \(userInfo.mbti!)"
        myAnimalFace.textColor = UIColor(cgColor: tintColor)
        myMajorAndMBTI.textColor = .gray

    }
    
    fileprivate func getUserInfo() -> Owner? {
        if let data = UserDefaults.standard.value(forKey:"myInfo") as? Data {
            let infoData = try! PropertyListDecoder().decode(Owner.self, from: data)
            
            return infoData
        }
        return nil
    }
    
    fileprivate func transImage(index: Int) -> String {
        switch index {
        case 1: return "dog"
        case 2: return "cat"
        case 3: return "rabbit"
        case 4: return "fox"
        case 5: return "bear"
        case 6: return "dino"
        default: return "nil"
        }
    }
    
    fileprivate func transString(index: Int) -> String {
        switch index {
        case 1: return "강아지상"
        case 2: return "고양이상"
        case 3: return "토끼상"
        case 4: return "여우상"
        case 5: return "곰돌이상"
        case 6: return "공룡상"
        default: return "nil"
        }
    }
}
