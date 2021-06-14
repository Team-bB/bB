//
//  OtherInfoVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/06/02.
//

import Foundation
import UIKit
import PanModal

class OtherInfoVC: UIViewController {
    
    let indicator = CustomIndicator()
    let reportReasons = reportModel().reportReasons
    var otherUserInfo: Owner?
    var otherAccountId: String?
    var conversationId: String?
    var blockDelegate: BlockDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = imageView.frame.width / 2
        self.imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        self.imageView.clipsToBounds = true
        
        updateUI()
    }
    
    @IBAction func blockButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "차단", message: "상대방을 차단하고 대화방을 나갑니다.\n채팅내역은 영구적으로 삭제됩니다.", preferredStyle: .alert)
        
        let noButton = UIAlertAction(title: "아니요", style: .cancel) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        let yesButton = UIAlertAction(title: "예", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self,
                  let otherId = strongSelf.otherAccountId,
                  let accountId = UserDefaults.standard.value(forKey: "accountId") as? String else { return }
            
            strongSelf.indicator.startAnimating(superView: strongSelf.view)
            
            BlockMemberAPI.shared.post(accountId: accountId, otherId: otherId) { result in
                switch result {

                case .success(let finalResult):
                    
                    if finalResult.result == "true" {
                        DispatchQueue.main.async {
                            strongSelf.indicator.stopAnimating()
                            strongSelf.dismiss(animated: true) {
                                strongSelf.blockDelegate?.blockUserButtonTapped()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            strongSelf.indicator.stopAnimating()
                            strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인") { _ in
                                strongSelf.dismiss(animated: true, completion: nil)
                            }
                        }
                    }

                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인") { _ in
                            strongSelf.dismiss(animated: true) {

                            }
                        }
                    }
                }
            }
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "신고 사유",
                                            message: "사유를 선택해주세요",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil))


        for reason in reportReasons {
            actionSheet.addAction(UIAlertAction(title: reason,
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else { return }
                                                    let alertController = UIAlertController(title: "신고", message: "정말로 신고하시겠습니까?", preferredStyle: .alert)
                                                    
                                                    let yesButton = UIAlertAction(title: "예", style: .default, handler: { _ in
                                                        guard let otherId = strongSelf.otherAccountId,
                                                              let accountId = UserDefaults.standard.value(forKey: "accountId") as? String else { return }
                                                        
                                                        strongSelf.indicator.startAnimating(superView: strongSelf.view)
                                                        
                                                        ReportMemberAPI.shared.post(accountId: accountId, otherId: otherId, content: reason) { result in
                                                            switch result {

                                                            case .success(let finalResult):
                                                                
                                                                if finalResult.result == "true" {
                                                                    DispatchQueue.main.async {
                                                                        strongSelf.indicator.stopAnimating()
                                                                        strongSelf.makeAlertBox(title: "신고완료", message: "신고가 접수되었습니다.", text: "확인") { _ in
                                                                            strongSelf.dismiss(animated: true, completion: nil)
                                                                        }
                                                                    }
                                                                } else {
                                                                    DispatchQueue.main.async {
                                                                        strongSelf.indicator.stopAnimating()
                                                                        strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인") { _ in
                                                                            strongSelf.dismiss(animated: true, completion: nil)
                                                                        }
                                                                    }
                                                                }
        
                                                            case .failure(let error):
                                                                print(error)
                                                                DispatchQueue.main.async {
                                                                    strongSelf.indicator.stopAnimating()
                                                                    strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인") { _ in
                                                                        strongSelf.dismiss(animated: true, completion: nil)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    })
                                                    
                                                    let noButton = UIAlertAction(title: "아니요", style: .cancel) { _ in
                                                        strongSelf.dismiss(animated: true, completion: nil)
                                                    }
                                            
                                                    alertController.addAction(yesButton)
                                                    alertController.addAction(noButton)
                                                    strongSelf.present(alertController, animated: true, completion: nil)
                                                }))
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func updateUI() {
        
        guard let otherUserInfo = otherUserInfo else { return }
        
        reportButton.setEnable(enable: true, backgroundColor: .systemRed)
        blockButton.setEnable(enable: true, backgroundColor: .lightGray)
        
        if let college = otherUserInfo.college,
           let mbti = otherUserInfo.mbti,
           let age = otherUserInfo.age,
           let height = otherUserInfo.height,
           let animal = otherUserInfo.animal_idx {
            collegeLabel.text = college
            mbtiLabel.text = mbti
            ageLabel.text = "\(age)살"
            heightLabel.text = "\(height)cm"
            imageView.image = UIImage(named: transAnimal(index: animal, isImage: true))
            nickNameLabel.text = otherUserInfo.nickname
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
extension OtherInfoVC: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(170)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(170)
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
