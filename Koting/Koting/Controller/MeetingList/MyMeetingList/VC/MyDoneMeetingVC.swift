//
//  MyDoneMeetingVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit
import PanModal

class MyDoneMeetingVC: UIViewController {

    var doneMeeting = [Meeting]()
    var deleteButtonTapped: (() -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        FetchMeetings()
    }
    override func viewWillAppear(_ animated: Bool) {
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
        DoneMeetingListAPI.shared.get(accountID: UserDefaults.standard.string(forKey: "accountId")) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let finalResult):
                strongSelf.doneMeeting = finalResult.result ?? []

                DispatchQueue.main.async {
                    print(self?.doneMeeting)
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

extension MyDoneMeetingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneMeeting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneMeetingCell", for: indexPath) as! DoneMeetingCell
        cell.animalShapeImage.image = UIImage(named: transImage(index: doneMeeting[indexPath.row].owner?.animal_idx ?? 0))
        cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        cell.collegeLabel.text = doneMeeting[indexPath.row].owner?.college
        cell.mbtiLabel.text = doneMeeting[indexPath.row].owner?.mbti
        cell.numberOfParticipants.text = doneMeeting[indexPath.row].player
        cell.nickNameLabel.text = doneMeeting[indexPath.row].owner?.nickname
        let createdDate = doneMeeting[indexPath.row].date
        let dateArr = createdDate?.components(separatedBy: "-")
        cell.dateLabel.text = (dateArr?[1] ?? "")+"/"+(dateArr?[2] ?? "")
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension MyDoneMeetingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "삭제") { (action, view, success) in
            self.doneMeeting.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            success(true)
        }
        self.deleteButtonTapped = { [unowned self] in
            DeleteCompleteMeetingAPI.shared.post(meetingId: doneMeeting[indexPath.row].meeting_id) { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let finalResult):
                    let result = finalResult.result
                    
                    if result == "deleteFail" {
                        DispatchQueue.main.async {
                            print("Fail")
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Success")
                        }
                    }
                case .failure:
                    break
                }
            }
        }
        action.image = UIImage(named: "icons8-trash-can-50")
        action.backgroundColor = .red
        
        return action
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = UIStoryboard(name: "MyMeetingList", bundle: nil).instantiateViewController(withIdentifier: "SimpleMeetingInfo") as! SimpleMeetingInfoViewController
            vc.meeting = doneMeeting[indexPath.row]
            presentPanModal(vc)
    }
}
