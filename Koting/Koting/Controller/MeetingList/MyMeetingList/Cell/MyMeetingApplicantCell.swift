//
//  MyMeetingApplicantCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import Foundation
import UIKit

class MyMeetingApplicantCell: UITableViewCell {
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
//
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        acceptBtn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        acceptBtn.layer.cornerRadius = 12
        rejectBtn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        rejectBtn.layer.cornerRadius = 12
        pageControl.hidesForSinglePage = true
//
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
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        pageControl.currentPage = indexPath.row
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.width
//        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
//        self.pageControl.currentPage = self.currentPage
        let width = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / width
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
        print("\(pageControl.currentPage)")
    }
}

extension MyMeetingApplicantCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = myMeeting?.participant.count ?? 0
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count>1)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplicantCollectionViewCell", for: indexPath) as! ApplicantCollectionViewCell
        cell.collegeLabel.text = myMeeting?.participant[indexPath.row].college
        cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.participant[indexPath.row].animal_idx ?? 0))
        cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        cell.ageLabel.text = String(myMeeting?.participant[indexPath.row].age ?? 0)
        cell.heightLabel.text = String(myMeeting?.participant[indexPath.row].height ?? 0)
        cell.mbtiLabel.text = myMeeting?.participant[indexPath.row].mbti
        cell.collectionCellView.layer.cornerRadius = 40
        cell.collectionCellView.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        cell.collectionCellView.layer.shadowOpacity = 1.0
        cell.collectionCellView.layer.shadowOffset = CGSize.zero
        cell.collectionCellView.layer.shadowRadius = 5
        
        self.acceptButtonTapped = { [unowned self] in
            let age = myMeeting?.participant[indexPath.row].age
            print(age ?? "0")
            AcceptMeetingAPI.shared.post(applyID: myMeeting?.participant[indexPath.row].apply_id) { [weak self] result in
                
                switch result {
                case .success(let finalResult):
                    if finalResult.result == "true" {
                        DispatchQueue.main.async {
                            parentVC.makeAlertBox(title: "알림", message: "수락 완료", text: "확인",handler: {(action: UIAlertAction!) in
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
            RejectMeetingAPI.shared.post(accountID: myMeeting?.participant[indexPath.row].apply_id) { [weak self] result in
                
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

extension MyMeetingApplicantCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
