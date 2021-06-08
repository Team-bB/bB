//
//  MeetingLIstVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import Alamofire
import PanModal

class MeetingListVC: UIViewController {
    
    private let indicator = CustomIndicator()
    let reportReasons = reportModel().reportReasons
    
    var meetings = [Meeting]()
    var myMeeting: Meeting?
        
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        lbl.text = "   동마담"
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = lbl
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = view.backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        FetchMeetings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FetchMeetings()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(scrollView.contentOffset.y > 0){
//            //self.navigationController?.navigationBar.prefersLargeTitles = false
//        }else {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//        }
//    }
    
    @objc private func didPullToRefresh() {
        print("Start Refresh")
        FetchMeetings()
    }
    // MARK: FetchMeetings
    func FetchMeetings() {
        indicator.startAnimating(superView: view)

        
        FetchMeetingRoomsAPI.shared.get(accountID: UserDefaults.standard.string(forKey: "accountId")) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let finalResult):
                strongSelf.meetings = finalResult.meeting
                strongSelf.myMeeting = finalResult.myMeeting
                
                DispatchQueue.main.async {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                    strongSelf.tableView.reloadData()
                    self?.indicator.stopAnimating()
                }
                
            case .failure:
                DispatchQueue.main.async {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                    self?.indicator.stopAnimating()
                }
                break
            }
        }
    }
    
    @objc func tap(_ sender: Any) {
        let vc = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CreateMeetingRoomVC") as! CreateMeetingRoomVC
        presentPanModal(vc)
    }
    
}

//MARK: EXTENSION TABLEVIEW DELEGATE AND DATA SOURCE
extension MeetingListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return meetings.count
        }else { return 1 }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "내 미팅"
        }else { return "미팅 리스트" }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if myMeeting == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoMyMeetingCell", for: indexPath) as! NoMyMeetingCell
                cell.buttonCreateMyMeeting = { [unowned self] in
                    cell.noMyMeeting.addTarget(self, action: #selector(tap), for: .primaryActionTriggered)
                }
                cell.selectionStyle = .none
                
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingCell", for: indexPath) as! MyMeetingCell
                
                cell.collegeName.text = myMeeting?.owner?.college
                cell.numberOfParticipants.text = myMeeting?.player
                cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.owner?.animal_idx ?? 0))
                cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
                cell.animalShapeImage.layer.masksToBounds = true
                cell.animalShapeImage.layer.borderWidth = 0
                cell.mbtiLabel.text = myMeeting?.owner?.mbti
                cell.nickNameLabel.text = myMeeting?.owner?.nickname
                let createdDate = myMeeting?.date
                let dateArr = createdDate?.components(separatedBy: "-")
                cell.dateLabel.text = (dateArr?[1] ?? "")+"/"+(dateArr?[2] ?? "")
                cell.selectionStyle = .none
                if myMeeting?.applierCnt == 1 {
                    cell.applyCount[0].isSelected = true
                    cell.applyCount[1].isSelected = false
                    cell.applyCount[2].isSelected = false
                }else if myMeeting?.applierCnt == 2 {
                    cell.applyCount[0].isSelected = true
                    cell.applyCount[1].isSelected = true
                    cell.applyCount[2].isSelected = false
                }else if myMeeting?.applierCnt == 3 {
                    cell.applyCount[0].isSelected = true
                    cell.applyCount[1].isSelected = true
                    cell.applyCount[2].isSelected = true
                }else {
                    cell.applyCount[0].isSelected = false
                    cell.applyCount[1].isSelected = false
                    cell.applyCount[2].isSelected = false
                }
                
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingListTableViewCell", for: indexPath) as! MeetingListTableViewCell
            
            cell.collegeName.text = meetings[indexPath.row].owner?.college ?? "단과대학"
            cell.numberOfParticipants.text = meetings[indexPath.row].player
            cell.animalShapeImage.image = UIImage(named: transImage(index: meetings[indexPath.row].owner?.animal_idx ?? 0))
            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2 //102~104 이미지 동그랗게 만드는코드 약간애매
            cell.animalShapeImage.layer.masksToBounds = true
            cell.animalShapeImage.layer.borderWidth = 0
            cell.mbtiLabel.text = meetings[indexPath.row].owner?.mbti
            cell.nickNameLabel.text = meetings[indexPath.row].owner?.nickname
            let createdDate = meetings[indexPath.row].date
            let dateArr = createdDate?.components(separatedBy: "-")
            cell.dateLabel.text = (dateArr?[1] ?? "")+"/"+(dateArr?[2] ?? "")
            if meetings[indexPath.row].applierCnt == 1 {
                cell.applyCount[0].isSelected = true
                cell.applyCount[1].isSelected = false
                cell.applyCount[2].isSelected = false
            }else if meetings[indexPath.row].applierCnt == 2 {
                cell.applyCount[0].isSelected = true
                cell.applyCount[1].isSelected = true
                cell.applyCount[2].isSelected = false
            }else if meetings[indexPath.row].applierCnt == 3 {
                cell.applyCount[0].isSelected = true
                cell.applyCount[1].isSelected = true
                cell.applyCount[2].isSelected = true
            }else {
                cell.applyCount[0].isSelected = false
                cell.applyCount[1].isSelected = false
                cell.applyCount[2].isSelected = false
            }

            return cell
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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.section == 1 else { return nil }
  
        let report = UIContextualAction(style: .normal, title: "신고") { [weak self] action, view, success in
            
            guard let strongSelf = self else { return }
            
            success(true)
            let actionSheet = UIAlertController(title: "신고 사유",
                                                message: "사유를 선택해주세요",
                                                preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "취소",
                                                style: .cancel,
                                                handler: nil))

 
            for reason in strongSelf.reportReasons {
                actionSheet.addAction(UIAlertAction(title: reason,
                                                    style: .default,
                                                    handler: { _ in
                                                        
                                                        let alertController = UIAlertController(title: "신고", message: "정말로 신고하시겠습니까?", preferredStyle: .alert)
                                                        
                                                        let yesButton = UIAlertAction(title: "예", style: .default, handler: { _ in
                                                            guard let accountId = UserDefaults.standard.value(forKey: "accountId") as? String else { return }
                                                            strongSelf.indicator.startAnimating(superView: view)
                                                            ReportMeetingAPI.shared.post(meetingId: strongSelf.meetings[indexPath.row].meeting_id ?? 0, accountId: accountId, content: reason) { result in
                                                                switch result {

                                                                case .success(let finalResult):
                                                                    
                                                                    if finalResult.result == "true" {
                                                                        DispatchQueue.main.async {
                                                                            strongSelf.indicator.stopAnimating()
                                                                            strongSelf.makeAlertBox(title: "신고완료", message: "신고가 접수되었습니다.", text: "확인")
                                                                        }
                                                                    } else {
                                                                        DispatchQueue.main.async {
                                                                            strongSelf.indicator.stopAnimating()
                                                                            strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인")
                                                                        }
                                                                    }
            
                                                                case .failure(let error):
                                                                    print(error)
                                                                    DispatchQueue.main.async {
                                                                        strongSelf.indicator.stopAnimating()
                                                                        strongSelf.makeAlertBox(title: "오류", message: "알 수 없는 오류가 발생했습니다.", text: "확인")
                                                                    }
                                                                }
                                                            }
                                                        })
                                                        
                                                        let noButton = UIAlertAction(title: "아니요", style: .cancel)
                                                
                                                        alertController.addAction(yesButton)
                                                        alertController.addAction(noButton)
                                                        strongSelf.present(alertController, animated: true, completion: nil)
                                                    }))
            }
            strongSelf.present(actionSheet, animated: true, completion: nil)
        }
        
        report.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions:[report])
    }
}

extension MeetingListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if myMeeting != nil {
                let vc = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyMeetingInfo") as! MyMeetingInfoViewController
                vc.meeting = myMeeting
                presentPanModal(vc)
            }else {print("clicked!!!")}
        }else {
            let vc = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MeetingDetailInfo") as! MeetingDetailInfoViewController
            vc.meeting = meetings[indexPath.row]
            presentPanModal(vc)
        }
    }
}
