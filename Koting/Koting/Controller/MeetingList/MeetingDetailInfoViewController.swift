//
//  MeetingDetailInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/23.
//

import UIKit
import PanModal

class MeetingDetailInfoViewController: UIViewController {
    
    private let indicator = CustomIndicator()
    
    var meeting: Meeting?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyBtnTapped: UIButton!
    

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
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        indicator.startAnimating(superView: view)
        
        ApplyMeetingAPI.shared.post(meetingId: meeting?.meeting_id) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                
                if finalResult.result == "applyMeetingSuccess" {
                    DispatchQueue.main.async {
                        self?.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "성공", message: "미팅신청에 성공했습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }else if finalResult.result == "applyMeetingApplied" {
                    DispatchQueue.main.async {
                        self?.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "실패", message: "이미 신청한 미팅입니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }else if finalResult.result == "applyMeetingRejected" {
                    DispatchQueue.main.async {
                        self?.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "실패", message: "거절된 미팅입니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self?.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "실패", message: "신청이 마감되었습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                    strongSelf.makeAlertBox(title: "실패", message: "Error", text: "확인") { (action) in
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                }
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
            numberOfParticipant.text = "\(meeting.player)"
            applyBtnTapped.setEnable(enable: true, backgroundColor: #colorLiteral(red: 0.1882352978, green: 0.8196078539, blue: 0.3450980484, alpha: 1))
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
extension MeetingDetailInfoViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(230)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(230)
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
