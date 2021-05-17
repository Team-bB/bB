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
    
    //var createMeetingRoom: UIViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블 뷰 셀 나누는 줄 없애는 코드
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissViewController"), object: nil)
        //setFloatingButton()
        
        setChatButton()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        FetchMeetings()
 
        
    }
    
    @objc private func didPullToRefresh() {
        print("Start Refresh")
        FetchMeetings()
    }
    // MARK: FetchMeetings
    func FetchMeetings() {
        
        if tableView.refreshControl?.isRefreshing == true {
            print("-----Refreshing Meetings-----\n")
        } else {
            print("-----Fetching Meetings-----\n")
        }
        
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
    
    // MARK: Create Floating Button
//    func setFloatingButton() {
//        let floatingButton = MDCFloatingButton()
//        floatingButton.mode = .expanded
//        let image = UIImage(systemName: "plus")
//        floatingButton.sizeToFit()
//        floatingButton.translatesAutoresizingMaskIntoConstraints = false //오토레이아웃 관련 이걸 true로 하면 자동으로 위치 바뀌나??
//        floatingButton.setTitle("미팅 개설", for: .normal)
//        floatingButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
//        floatingButton.setImage(image, for: .normal)
//        floatingButton.setImageTintColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
//        floatingButton.backgroundColor = .white
//        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
//        view.addSubview(floatingButton)
//        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 256))
//    }
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingCell", for: indexPath) as! MyMeetingCell
            if myMeeting == nil {
                cell.myMeetingStackView.isHidden = true
                cell.noMyMeeting.isHidden = false
                cell.buttonCreateMyMeeting = { [unowned self] in
                    cell.noMyMeeting.addTarget(self, action: #selector(tap), for: .touchUpInside)
                }
            }else {
                cell.noMyMeeting.isHidden = true
                cell.myMeetingStackView.isHidden = false
                
            }
                cell.collegeName.text = myMeeting?.owner?.college
                cell.numberOfParticipants.text = myMeeting?.player
                cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.owner?.animal_idx ?? 0))
                cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
                cell.animalShapeImage.layer.masksToBounds = true
                cell.animalShapeImage.layer.borderWidth = 0
                
                cell.tableViewCellLayer.layer.cornerRadius = 20
                cell.tableViewCellLayer.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
                cell.tableViewCellLayer.layer.shadowOpacity = 1.0
                cell.tableViewCellLayer.layer.shadowOffset = CGSize.zero
                cell.tableViewCellLayer.layer.shadowRadius = 6
                
                return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingListTableViewCell", for: indexPath) as! MeetingListTableViewCell
            cell.tableViewCellLayer.layer.cornerRadius = 20
            
            
            cell.collegeName.text = meetings[indexPath.row].owner?.college ?? "단과대학"
            cell.numberOfParticipants.text = meetings[indexPath.row].player
            cell.animalShapeImage.image = UIImage(named: transImage(index: meetings[indexPath.row].owner?.animal_idx ?? 0))
            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2 //102~104 이미지 동그랗게 만드는코드 약간애매
            cell.animalShapeImage.layer.masksToBounds = true
            cell.animalShapeImage.layer.borderWidth = 0
            
            cell.tableViewCellLayer.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
            cell.tableViewCellLayer.layer.shadowOpacity = 1.0
            cell.tableViewCellLayer.layer.shadowOffset = CGSize.zero
            cell.tableViewCellLayer.layer.shadowRadius = 6
            
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
            performSegue(withIdentifier: "MyMeetingInfo", sender: indexPath.row)
        }else {
            performSegue(withIdentifier: "MeetingDetailInfo", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MeetingDetailInfo" {
            let vc = segue.destination as? MeetingDetailInfoViewController
            if let index = sender as? Int {
                vc?.meeting = meetings[index]
            }
        }else if segue.identifier == "MyMeetingInfo" {
            let vc = segue.destination as? MyMeetingInfoViewController
//            if let index = sender as? Int {
//                vc?.meeting = myMeeting
//            }
            vc?.meeting = myMeeting
        }
    }
}

// MARK: - Chat
extension MeetingListVC {
    func setChatButton() {
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .organize,
                                                                   target: self,
                                                                   action: #selector(didTapChatButton)))
    }
    
    @objc func didTapChatButton() {
        
        let nextVC = ConversationVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
