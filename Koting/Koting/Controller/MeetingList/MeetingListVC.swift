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

    
    @IBOutlet weak var tableView: UITableView!
    
    var meetingList: [Meeting] = []
    var myInfo: Info?
    
    //MARK: 더미데이터
    var testData1: Meeting = Meeting(numberOfParticipants: "3", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "공과대학", major: "정보통신공학과", age: "25", height: "188", mbti: "ESTP", email: "ghdghkgud@dgu.ac.kr"))
    var testData2: Meeting = Meeting(numberOfParticipants: "2", progressCondition: "매칭완료", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "사회과학대학", major: "정치외교학과", age: "25", height: "180", mbti: "ESTP", email: "kkkniga@dgu.ac.kr"))
    var testData3: Meeting = Meeting(numberOfParticipants: "1", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "불교대학", major: "불교학부", age: "25", height: "179", mbti: "ESTP", email: "norply@dgu.ac.kr"))
    var testData4: Meeting = Meeting(numberOfParticipants: "4", progressCondition: "진행중", userInfo: Info(sex: "male", phoneNumber: "01041728922", college: "문과대학", major: "사학과", age: "25", height: "179", mbti: "ESTP", email: "chlwodnjs97@dgu.ac.kr"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        meetingList = [testData1,testData2,testData3,testData4]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //getMeetingListAndMyInfo()
        setFloatingButton()
        
    }
    // MARK: get data
//    func getMeetingListAndMyInfo() {
//        MeetingListAndMyInfoAPI.shared.post() { [weak self] result in
//
//            guard let self = self else {return}
//
//            switch result {
//            case .success(let APIResponse):
//                self.meetingList = APIResponse.meetingList
//                self.myInfo = APIResponse.myInfo
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            case .failure(let error):
//                print("\(error)\n 미팅리스트와 내 정보를 불러오는중 발생한 에러")
//            }
//        }
//    }
    
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
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingListTableViewCell", for: indexPath) as! MeetingListTableViewCell
        cell.collegeName.text = meetingList[indexPath.row].userInfo.college
        cell.numberOfParticipants.text = meetingList[indexPath.row].numberOfParticipants
        
        return cell
    }
    
}

extension MeetingListVC: UITableViewDelegate {
    
}



//    private func fetchData() {
//        let url = API.shared.BASE_URL + ""
//        let request = URLRequest(url: URL(string: url)!)
//
//        AF.request(request).responseJSON { (response) in
//            switch response.result {
//            case .success(let res):
//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
//                    let json = try JSONDecoder().decode(APIResponse.self, from: jsonData)
//                    self.meetingList = json.MeetingList
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                } catch(let error) {
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    private func post() {
//        let url = API.shared.BASE_URL + "/checkStatus"
//        var request = URLRequest(url: URL(string: url)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.timeoutInterval = 10
//
//        //POST로 보낼 정보
//        guard let accountId = UserDefaults.standard.string(forKey: "account_id") else { return }
//        let params = ["account_id" : accountId] as Dictionary
//
//        // httpBody에 parameters 추가
//        do {
//            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            print("http Body Error")
//        }
//
//        AF.request(request).responseJSON { (response) in
//            switch response.result {
//            case .success:
//                print("\n\nPOST SUCCESS")
//                if let _ = response.value {
//                    let decoder = JSONDecoder()
//                    do {
//                        let product = try decoder.decode(APIResponse.self, from: response.data!)
//
//                        print("받아와짐")
//                        self.meetingList = product.MeetingList
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//
//                        // 메일 인증 true면 보낸디
//                    } catch {
//                        print(error)
//                    }
//                }
//
//            case .failure(let error):
//                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
//            }
//        }
//    }
