//
//  MyMeetingApplicantCell.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import Foundation
import UIKit

class MyMeetingApplicantCell: UITableViewCell {
//    var myMeeting: MyMeeting? {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    var currentPage:Int = 0
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        acceptBtn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        acceptBtn.layer.cornerRadius = 12
        rejectBtn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        rejectBtn.layer.cornerRadius = 12
        
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
    }
    
    @IBAction func rejectBtnTapped(_ sender: Any) {
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}

extension MyMeetingApplicantCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return myMeeting?.participant.count ?? 0
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplicantCollectionViewCell", for: indexPath) as! ApplicantCollectionViewCell
//        cell.collegeLabel.text = myMeeting?.participant[indexPath.row].college
//        cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.participant[indexPath.row].animal_idx ?? 0))
//        cell.animalShapeImage.layer.cornerRadius =  cell.animalShapeImage.frame.size.height/2
//        cell.animalShapeImage.layer.masksToBounds = true
//        cell.animalShapeImage.layer.borderWidth = 0
//        cell.ageLabel.text = String(myMeeting?.participant[indexPath.row].age ?? 0)
//        cell.heightLabel.text = String(myMeeting?.participant[indexPath.row].height ?? 0)
//        cell.mbtiLabel.text = myMeeting?.participant[indexPath.row].mbti
        cell.collegeLabel.text = "공과대학"
        cell.animalShapeImage.image = UIImage(named: transImage(index: 1))
        cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        cell.ageLabel.text = "23"
        cell.heightLabel.text = "155"
        cell.mbtiLabel.text = "ESTP"
        cell.collectionCellView.layer.cornerRadius = 40
        cell.collectionCellView.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        cell.collectionCellView.layer.shadowOpacity = 1.0
        cell.collectionCellView.layer.shadowOffset = CGSize.zero
        cell.collectionCellView.layer.shadowRadius = 5
        
        return cell
    }
    
    
}

extension MyMeetingApplicantCell: UICollectionViewDelegate {
    
}

