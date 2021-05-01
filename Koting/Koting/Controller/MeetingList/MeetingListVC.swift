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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블 뷰 셀 나누는 줄 없애는 코드
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissViewController"), object: nil)
        setFloatingButton()
        
        
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
        FetchMeetingRoomsAPI.shared.get { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let finalResult):
                print("-------Fetching Success-------\n")
                strongSelf.meetings = finalResult.meeting
                
                DispatchQueue.main.async {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                }
                print("\n--------- FetchMeetings Codable Error ------------\n")
                print(error)
            }
        }
    }
    
    // MARK: Create Floating Button
    func setFloatingButton() {
        let floatingButton = MDCFloatingButton()
        floatingButton.mode = .expanded
        let image = UIImage(systemName: "pencil")
        floatingButton.sizeToFit()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false //오토레이아웃 관련 이걸 true로 하면 자동으로 위치 바뀌나??
        floatingButton.setTitle("방 개설", for: .normal)
        floatingButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        floatingButton.setImage(image, for: .normal)
        floatingButton.setImageTintColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        floatingButton.backgroundColor = .white
        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(floatingButton)
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 256))
    }
    
    @objc func tap(_ sender: Any) {
        let vc = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CreateMeetingRoomVC") as! CreateMeetingRoomVC
        presentPanModal(vc)
    }
    
}

//MARK: EXTENSION TABLEVIEW DELEGATE AND DATA SOURCE
extension MeetingListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingListTableViewCell", for: indexPath) as! MeetingListTableViewCell
        cell.tableViewCellLayer.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cell.tableViewCellLayer.layer.cornerRadius = 20
        cell.tableViewCellLayer.layer.borderWidth = 2
        cell.tableViewCellLayer.layer.masksToBounds = true
        
        cell.tableViewCellLayer.layer.shadowRadius = 5
        cell.tableViewCellLayer.layer.shadowOpacity = 0.5
        cell.tableViewCellLayer.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.tableViewCellLayer.layer.shadowColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        cell.collegeName.text = meetings[indexPath.row].owner?.college ?? "단과대학"
        cell.numberOfParticipants.text = meetings[indexPath.row].player
        cell.animalShapeImage.image = UIImage(named: "image")
        cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2 //102~104 이미지 동그랗게 만드는코드 약간애매
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        
        return cell
    }
    
}

extension MeetingListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MeetingDetailInfo", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MeetingDetailInfo" {
            let vc = segue.destination as? MeetingDetailInfoViewController
            if let index = sender as? Int {
                vc?.meeting = meetings[index]
            }
        }
    }
}
