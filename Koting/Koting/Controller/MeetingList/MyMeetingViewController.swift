//
//  MyMeetingViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/23.
//

import UIKit
import Alamofire

class MyMeetingViewController: UIViewController {
    
    private var myMeeting: MyMeeting?
    private var applyList = [Meeting]()
    
    private let sections: [String] = ["MyMeeting","Applies"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블 뷰 셀 줄 없애기
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
    }
 
    @objc private func didPullToRefresh() {
        print("Start Refresh")
        FetchMeetings()
    }
 
    func FetchMeetings() {
        if tableView.refreshControl?.isRefreshing == true {
            print("-----Refreshing MyMeetings-----\n")
        }else {
            print("-----Fetching MyMeetings-----\n")
        }
        MyMeetingListAPI.shared.get { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let finalResult):
                strongSelf.myMeeting = finalResult.myCreatetion
                strongSelf.applyList = finalResult.myApplies
                
                
                DispatchQueue.main.async {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
                
            case .failure:
                DispatchQueue.main.async {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                }
                break
            }
        }
    }
}

extension MyMeetingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myMeeting?.participant.count ?? 0
        }else if section == 1{
            return applyList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingCell", for: indexPath) as! MyMeetingTableViewCell
            cell.stackViewCellLayer.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.stackViewCellLayer.layer.cornerRadius = 20
            cell.stackViewCellLayer.layer.borderWidth = 2
            cell.stackViewCellLayer.layer.masksToBounds = true
            
            cell.collegeName.text = myMeeting?.myMeeting.owner?.college
            cell.numberOfParticipants.text = myMeeting?.myMeeting.player
            cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.myMeeting.owner?.animal_idx ?? 0))
            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
            cell.animalShapeImage.layer.masksToBounds = true
            cell.animalShapeImage.layer.borderWidth = 0
            
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyListCell", for: indexPath) as! ApplyListTableViewCell
            cell.stackViewCellLayer.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.stackViewCellLayer.layer.cornerRadius = 20
            cell.stackViewCellLayer.layer.borderWidth = 2
            cell.stackViewCellLayer.layer.masksToBounds = true
            
            cell.collegeName.text = applyList[indexPath.row].owner?.college
            cell.numberOfParticipants.text = applyList[indexPath.row].player
            cell.animalShapeImage.image = UIImage(named: transImage(index: applyList[indexPath.row].owner?.animal_idx ?? 0))
            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
            cell.animalShapeImage.layer.masksToBounds = true
            cell.animalShapeImage.layer.borderWidth = 0
            
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///
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
}
