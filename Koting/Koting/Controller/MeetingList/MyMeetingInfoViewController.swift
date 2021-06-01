//
//  MyMeetingInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit
import PanModal

class MyMeetingInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var numberOfParticipant: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    var meeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            deleteBtn.setEnable(enable: true, backgroundColor: .systemRed)
            contentLabel.text = meeting.link
            nickNameLabel.text = owner.nickname
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "알림", message: "미팅을 삭제 하시겠습니까?", preferredStyle: .alert)
        let removeButton = UIAlertAction(title: "삭제", style: .destructive) { _ in self.deleteMeeting() }
        let okButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(removeButton)
        alertController.addAction(okButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteMeeting() {
        DeleteMeetingRoomAPI.shared.delete() { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                let result = finalResult.result
                
                if result == "true" {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "알림", message: "미팅을 삭제했습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "알림", message: "삭제에 실패했습니다..", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case .failure:
                break
            }
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
extension MyMeetingInfoViewController: PanModalPresentable {

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
