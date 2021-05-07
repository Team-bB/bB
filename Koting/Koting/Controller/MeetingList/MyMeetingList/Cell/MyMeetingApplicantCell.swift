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
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
        return myMeeting?.participant.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplicantCollectionViewCell", for: indexPath) as! ApplicantCollectionViewCell
        cell.collegeLabel.text = myMeeting?.participant[indexPath.row].college
        cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.participant[indexPath.row].animal_idx ?? 0))
        cell.animalShapeImage.layer.cornerRadius =  cell.animalShapeImage.frame.size.height/2
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        cell.ageLabel.text = String(myMeeting?.participant[indexPath.row].age ?? 0)
        cell.heightLabel.text = String(myMeeting?.participant[indexPath.row].height ?? 0)
        cell.mbtiLabel.text = myMeeting?.participant[indexPath.row].mbti
        
        return cell
    }
    
    
}

extension MyMeetingApplicantCell: UICollectionViewDelegate {
    
}

