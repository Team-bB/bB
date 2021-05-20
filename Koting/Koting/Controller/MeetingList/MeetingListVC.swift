//
//  MeetingLIstVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialButtons
import PanModal

class MeetingListVC: UIViewController {
    var meetings = [Meeting]()
    var myMeeting: Meeting?
        
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.8, height: 44))
        lbl.text = "코 팅"
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = lbl
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        
        //tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블 뷰 셀 나누는 줄 없애는 코드
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissViewController"), object: nil)
        
//        setChatButton()
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
        FetchMeetingRoomsAPI.shared.get(accountID: UserDefaults.standard.string(forKey: "accountId")) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let finalResult):
                strongSelf.meetings = finalResult.meeting
                strongSelf.myMeeting = finalResult.myMeeting
                
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
                    cell.noMyMeeting.addTarget(self, action: #selector(tap), for: .touchUpInside)
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
                cell.selectionStyle = .none
                
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
}

extension MeetingListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if myMeeting != nil {
                let vc = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyMeetingInfo") as! MyMeetingInfoViewController
                vc.meeting = myMeeting
                presentPanModal(vc)
            }
        }else {
            let vc = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MeetingDetailInfo") as! MeetingDetailInfoViewController
            vc.meeting = meetings[indexPath.row]
            presentPanModal(vc)
        }
    }
}

// MARK: - Chat
//extension MeetingListVC {
//    func setChatButton() {
//
//        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .organize,
//                                                                   target: self,
//                                                                   action: #selector(didTapChatButton)))
//    }
//
//    @objc func didTapChatButton() {
//
//        let nextVC = ConversationVC()
//        navigationController?.pushViewController(nextVC, animated: true)
//    }
//}
