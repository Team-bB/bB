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
    
    //MARK: 더미데이터
    /*
    var testData1: Meeting = Meeting(numberOfParticipants: "3", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "공과대학", major: "정보통신공학과", age: "25", height: "188", mbti: "ESTP", email: "ghdghkgud@dgu.ac.kr"))
    var testData2: Meeting = Meeting(numberOfParticipants: "2", progressCondition: "매칭완료", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "사회과학대학", major: "정치외교학과", age: "25", height: "180", mbti: "ESTP", email: "kkkniga@dgu.ac.kr"))
    var testData3: Meeting = Meeting(numberOfParticipants: "1", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "불교대학", major: "불교학부", age: "25", height: "179", mbti: "ESTP", email: "norply@dgu.ac.kr"))
    var testData4: Meeting = Meeting(numberOfParticipants: "4", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "문과대학", major: "사학과", age: "25", height: "179", mbti: "ESTP", email: "chlwodnjs97@dgu.ac.kr"))
    var testData5: Meeting = Meeting(numberOfParticipants: "1", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "문과대학", major: "사학과", age: "25", height: "179", mbti: "ESTP", email: "chlwodnjs97@dgu.ac.kr"))
    var testData6: Meeting = Meeting(numberOfParticipants: "3", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "문과대학", major: "사학과", age: "25", height: "179", mbti: "ESTP", email: "chlwodnjs97@dgu.ac.kr"))
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        meetingList = [testData1,testData2,testData3,testData4,testData5,testData6]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블 뷰 셀 나누는 줄 없애는 코드
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissViewController"), object: nil)
        //getMeetingListAndMyInfo()
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
        floatingButton.setTitleColor(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), for: .normal)
        floatingButton.setImage(image, for: .normal)
        floatingButton.setImageTintColor(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), for: .normal)
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
        cell.tableViewCellLayer.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        cell.tableViewCellLayer.layer.cornerRadius = 20
        cell.tableViewCellLayer.layer.borderWidth = 2
        cell.collegeName.text = meetings[indexPath.row].owner.college
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
        performSegue(withIdentifier: "MeetingDetailInfo", sender: meetingList[indexPath.row])
    }
}
