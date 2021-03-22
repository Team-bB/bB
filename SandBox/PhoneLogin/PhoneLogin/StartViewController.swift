//
//  StartViewController.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/19.
//

import UIKit
import Alamofire

struct Status: Codable {
    var result: Bool
}

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        autoLogin()
        // Do any additional setup after loading the view.
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        if !checkAccountId() {
            guard let phoneAuthVC = self.storyboard?.instantiateViewController(identifier: "PhoneAuth") else {return}
            phoneAuthVC.modalPresentationStyle = .fullScreen
            self.present(phoneAuthVC, animated: false)
        } else {
            // 가입후 인증 안된애들
            postText()
        }
    }
    private func checkAccountId() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: "accountId") else { return false }
        
        return true
    }
    
//    private func checkMailAuth() -> Bool {
//
//        let isTrue = UserDefaults.standard.bool(forKey: "mailAuth")
//
//        if isTrue { return true }
//
//        return false
//    }
    
    private func autoLogin() {
        
        DispatchQueue.global().async {
            
            // 유저 디폴트 O 메일 인증 O -> 미팅리스트
            if self.checkAccountId() {
                self.postText()
            // 유저 디폴트 O 메일 인증 X ->  alert
            } else { return }
        }
        
    }
    
    func Output_Alert(title : String, message : String, text : String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    private func postText() {
        let url = API.shared.BASE_URL + "/checkStatus"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        guard let id = UserDefaults.standard.string(forKey: "accountId") else { return  }
        let params = [
            "account_id" : id
                    ] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("\n\nPOST 성공")
                if let _ = response.value {
                    let decoder = JSONDecoder()
                    do {
                        let product = try decoder.decode(Status.self, from: response.data!)
                        print(product.result)
                        
                        // 메일 인증 true면 보낸디
                        if product.result {
                            
                            DispatchQueue.main.async {
                                guard let meetingListVC = self.storyboard?.instantiateViewController(identifier: "MeetingList") else {return}
                                meetingListVC.modalPresentationStyle = .fullScreen
                                self.present(meetingListVC, animated: false)
                            }
                            
                        } else {
                            self.Output_Alert(title: "알림", message: "메일 인증을 완료하세요.", text: "확인")
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}
