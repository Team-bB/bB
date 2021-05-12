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
//    var myMeeting: MyMeeting = MyMeeting(myMeeting: Meeting(owner: Owner(college: "이과대학", major: "화학과", sex: "남", mbti: "ENTP", animal_idx: 1, age: 22, height: 176), meeting_id: 111, link: "adsf", player: "3:#"),
//                                         participant: [Owner(college: "공과대학", major: "정보통신공학과", sex: "여", mbti: "INFP", animal_idx: 3, age: 20, height: 150),
//                                                       Owner(college: "문과대학", major: "국어문예창작학부", sex: "여", mbti: "ESFP", animal_idx: 4, age: 27, height: 155),
//                                                       Owner(college: "사회과학대학", major: "경제학과", sex: "여", mbti: "INTF", animal_idx: 2, age: 24, height: 160)])

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingApplicantCell", for: indexPath) as! MyMeetingApplicantCell
            if myMeeting?.participant.count == 0 {
                return UITableViewCell()
            }
            cell.collectionView.tag = indexPath.row
            cell.myMeeting = myMeeting
            cell.setColleciontionViewWith()
            cell.parentVC = self
            cell.buttonReloadData = { [unowned self] in
                FetchMeetings()
                tableView.reloadData()
            }
            
            let bgView = UIView()
            bgView.backgroundColor = .white
            cell.selectedBackgroundView = bgView
            
            return cell
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
            if myApplies[indexPath.row].apply_status == "WAIT" {
                cell.progressLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else { cell.progressLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)}

            let bgView = UIView()
            bgView.backgroundColor = .white
            cell.selectedBackgroundView = bgView
            print(myApplies)
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
//        if indexPath.section == 1{
//            print(myApplies[indexPath.row].meeting_id)
//        }
    }
    
}
