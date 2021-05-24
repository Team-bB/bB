//
//  MyMeetingApplicantCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import Foundation
import UIKit

class MyMeetingApplicantCell: UITableViewCell {
    
    private var users = [[String: String]]()
    
    var myMeeting: MyMeeting? {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentPage:Int = 0
    
    var parentVC: UIViewController!
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        acceptBtn.setDefault()
        rejectBtn.setDefault()
        pageControl.hidesForSinglePage = true
    }
    func setColleciontionViewWith(){
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
//        pageControl.hidesForSinglePage = true
    }

    var buttonReloadData: (() -> ())?
    var acceptButtonTapped: (() -> ())?
    var rejectButtonTapped: (() -> ())?
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        acceptButtonTapped?()
    }

    @IBAction func rejectBtnTapped(_ sender: Any) {
        rejectButtonTapped?()
    }
    
    func transImage(index: Int) -> String {
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
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        let page:Int? = sender.currentPage
        var frame: CGRect = self.collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / width
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
    }
}

extension MyMeetingApplicantCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = myMeeting?.participant?.count ?? 0
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count>1)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplicantCollectionViewCell", for: indexPath) as! ApplicantCollectionViewCell
        cell.collegeLabel.text = myMeeting?.participant?[indexPath.row].college
        cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.participant?[indexPath.row].animal_idx ?? 0))
        cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        cell.ageLabel.text = String(myMeeting?.participant?[indexPath.row].age ?? 0)
        cell.heightLabel.text = String(myMeeting?.participant?[indexPath.row].height ?? 0)
        cell.mbtiLabel.text = myMeeting?.participant?[indexPath.row].mbti
        cell.collectionCellView.layer.borderWidth = 0.3
        cell.collectionCellView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.numberOfParticipants.text = myMeeting?.myMeeting.player
        cell.nickNameLabel.text = myMeeting?.participant?[indexPath.row].nickname
        
        var applyID: String?
        //var college: String?
        
        acceptButtonTapped = { [unowned self] in
            if pageControl.currentPage == 0 {
                applyID = myMeeting?.participant?[0].apply_id
            }
            else if pageControl.currentPage == 1 {
                applyID = myMeeting?.participant?[1].apply_id
            }
            else {
                applyID = myMeeting?.participant?[2].apply_id
            }
            //print(college ?? "단과대학")
            AcceptMeetingAPI.shared.post(applyID: applyID) { result in

                switch result {
                case .success(let finalResult):

                    /// 채팅방을 개설후 상대방에게 기본 메시지를 보냅니다.
                    if finalResult.result == "true" {

                        guard let targetUserEmail = finalResult.targetUserEmail else { return }

                        ConversationVC.createNewConversation(name: "상대닉네임", email: targetUserEmail)

                        DispatchQueue.main.async {
                            parentVC.makeAlertBox(title: "수락완료", message: "새로운 채팅이 개설되었습니다!!\n채팅탭에서 확인해주세요.", text: "확인",handler: {(action: UIAlertAction!) in
                                buttonReloadData!()
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            parentVC.makeAlertBox(title: "알림", message: "수락 실패", text: "확인",handler: {(action: UIAlertAction!) in
                                buttonReloadData!()
                            })
                        }
                    }
                case .failure:
                    parentVC.makeAlertBox(title: "알림", message: "일어날수 없는일 일어난다면 문의해주세요 제발", text: "확인",handler:{(action: UIAlertAction!) in
                        buttonReloadData!()
                    })
                }
            }
        }
        
        self.rejectButtonTapped = { [unowned self] in
            if pageControl.currentPage == 0 {
                applyID = myMeeting?.participant?[0].apply_id
            }
            else if pageControl.currentPage == 1 {
                applyID = myMeeting?.participant?[1].apply_id
            }
            else {
                applyID = myMeeting?.participant?[2].apply_id
            }
            //print(college ?? "단과대학")
            RejectMeetingAPI.shared.post(applyID: applyID) { [weak self] result in

                switch result {
                case .success(let finalResult):
                    if finalResult.result == "true" {
                        DispatchQueue.main.async {
                            parentVC.makeAlertBox(title: "알림", message: "거절 완료", text: "확인",handler: {(action: UIAlertAction!) in
                                buttonReloadData!()
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            parentVC.makeAlertBox(title: "알림", message: "거절 실패", text: "확인",handler: {(action: UIAlertAction!) in
                                buttonReloadData!()
                            })
                        }
                        }
                case .failure:
                    parentVC.makeAlertBox(title: "알림", message: "일어날수 없는일 일어난다면 문의해주세요 제발", text: "확인",handler: {(action: UIAlertAction!) in
                        buttonReloadData!()
                    })
                }
            }
        }
        return cell
    }
    
}

extension MyMeetingApplicantCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width  , height:  collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
}
