//
//  MeetingDetailInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/23.
//

import UIKit

class MeetingDetailInfoViewController: UIViewController {
    
    var meeting: Meeting?
    @IBOutlet weak var meetingInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyBtnTapped: UIButton!
    
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meetingInfoView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.meetingInfoView.layer.cornerRadius = 20
        self.meetingInfoView.layer.borderWidth = 2

        
        self.imageView.layer.cornerRadius = imageView.frame.width / 2
        self.imageView.layer.borderWidth = 1
        self.imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        self.imageView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.imageView.clipsToBounds = true
        
        updateUI()
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        
        ApplyMeetingAPI.shared.post(meetingId: meeting?.meeting_id) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                
                if finalResult.result == "applyMeetingSuccess" {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "성공", message: "미팅을 신청했습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "실패", message: "신청이 마감되었습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case .failure:
                break
            }
        }
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
            animalLabel.text = transAnimal(index: animal, isImage: false) + "상"
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
