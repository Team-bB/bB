//
//  MyMeetingInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit

class MyMeetingInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    var meeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
    }
    
    func deleteMeeting() {
        DeleteMeetingRoomAPI.shared.post() { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                let result = finalResult.result
                
                if result == "deleteFail" {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "알림", message: "삭제에 실패했습니다..", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "알림", message: "미팅을 삭제했습니다.", text: "확인") { (action) in
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
