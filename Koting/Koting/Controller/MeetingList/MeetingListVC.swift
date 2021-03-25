//
//  MeetingLIstVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import Alamofire

class MeetingListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var meetingList: [Meeting] = []
    var myInfo: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //fetchData()
        
    }
    
    func getMeetingListAndMyInfo() {
        MeetingListAndMyInfoAPI.shared.post() { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let APIResponse):
                self.meetingList = APIResponse.meetingList
                self.myInfo = APIResponse.myInfo
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("\(error)\n 미팅리스트와 내 정보를 불러오는중 발생한 에러")
            }
        }
    }
    

    //MARK: Alamofire GET
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
}

//MARK: EXTENSION TABLEVIEW DELEGATE AND DATA SOURCE
extension MeetingListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingListTableViewCell", for: indexPath) as! MeetingListTableViewCell
        cell.collegeName.text = meetingList[indexPath.row].college
        cell.numberOfParticipants.text = meetingList[indexPath.row].numberOfParticipants
        
        return cell
    }
}

extension MeetingListVC: UITableViewDelegate {
    
}
