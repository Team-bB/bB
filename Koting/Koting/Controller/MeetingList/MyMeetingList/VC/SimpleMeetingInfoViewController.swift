//
//  SimpleMeetingInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/20.
//

import UIKit
import PanModal

class SimpleMeetingInfoViewController: UIViewController {

    
    var meeting: Meeting?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var numberOfParticipant: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.layer.cornerRadius = imageView.frame.width / 2
        self.imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        self.imageView.clipsToBounds = true
        
        updateUI()
    }
    
    private func updateUI() {
        
        guard let meeting = meeting, let owner = meeting.owner else { return }
        
        if let college = owner.college,
           let mbti = owner.mbti,
           let age = owner.age,
           let height = owner.height,
           let animal = owner.animal_idx {
            collegeLabel.text = college
            mbtiLabel.text = mbti
            ageLabel.text = "\(age)살"
            heightLabel.text = "\(height)cm"
            imageView.image = UIImage(named: transAnimal(index: animal, isImage: true))
            numberOfParticipant.text = "\(meeting.player)"
            contentLabel.text = meeting.link
            nickNameLabel.text = owner.nickname
        }
    }
    private func transAnimal(index: Int, isImage: Bool) -> String {
        if isImage {
            switch index {
            case 1: return "dog"
            case 2: return "cat"
            case 3: return "rabbit"
            case 4: return "fox"
            case 5: return "bear"
            case 6: return "dino"
            default: return "nil"
            }
        } else {
            switch index {
            case 1: return "강아지"
            case 2: return "고양이"
            case 3: return "토끼"
            case 4: return "여우"
            case 5: return "곰돌이"
            case 6: return "공룡"
            default: return "동물"
            }
        }
    }
}
// MARK:- PanModal 설정
extension SimpleMeetingInfoViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(200)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(200)
    }

    var anchorModalToLongForm: Bool {
        return true
    }
    
    var cornerRadius: CGFloat {
        get { return 0 }
    }
    
    var showDragIndicator: Bool {
        return false
    }
}
