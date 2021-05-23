//
//  MyContinueMeetingVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit

class MyContinueMeetingVC: UIViewController {

    var myApplies = [Meeting]()
    var myMeeting: MyMeeting?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        FetchMeetings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FetchMeetings()
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
                strongSelf.myMeeting = finalResult.myCreation
                strongSelf.myApplies = finalResult.myApplies


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

extension MyContinueMeetingVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return myApplies.count
        }else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard (myMeeting?.participant) != nil else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoAppliesCell", for: indexPath) as! NoAppliesCell
                cell.noAppliesLabel.text = "받은 신청이 없습니다."
                cell.selectionStyle = .none
                
                return cell
            }
//            if participant.count == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "NoAppliesCell", for: indexPath) as! NoAppliesCell
//                cell.noAppliesLabel.text = "지원받은 신청이 없습니다."
//
//                return cell
//            } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingApplicantCell", for: indexPath) as! MyMeetingApplicantCell
            cell.collectionView.tag = indexPath.row
            cell.myMeeting = myMeeting
            cell.setColleciontionViewWith()
            cell.parentVC = self
            cell.buttonReloadData = { [unowned self] in
                FetchMeetings()
            }
            cell.selectionStyle = .none
            
            return cell
            //}
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyApplyCell", for: indexPath) as! MyApplyCell
            cell.animalShapeImage.image = UIImage(named: transImage(index: myApplies[indexPath.row].owner?.animal_idx ?? 0))
            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
            cell.animalShapeImage.layer.masksToBounds = true
            cell.animalShapeImage.layer.borderWidth = 0
            cell.collegeLabel.text = myApplies[indexPath.row].owner?.college
            cell.mbtiLabel.text = myApplies[indexPath.row].owner?.mbti
            cell.numberOfParticipants.text = myApplies[indexPath.row].player
            cell.progressLabel.text = myApplies[indexPath.row].apply_status
            cell.selectionStyle = .none
            if myApplies[indexPath.row].apply_status == "거절됨" {
                cell.progressLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else { cell.progressLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)}
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "받은 신청"}
        else { return "지원한 미팅"}
    }
}

extension MyContinueMeetingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UIStoryboard(name: "MyMeetingList", bundle: nil).instantiateViewController(withIdentifier: "SimpleMeetingInfo") as! SimpleMeetingInfoViewController
            vc.meeting = myApplies[indexPath.row]
            presentPanModal(vc)
        }
    }
}
