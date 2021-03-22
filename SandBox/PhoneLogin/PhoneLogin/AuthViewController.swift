//
//  AuthViewController.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/12.
//

import UIKit
import Alamofire

struct phoneAuth: Codable {
    var result: String
}

class AuthViewController: UIViewController {
    // MARK:- 변수 선언
    let maxLength = 4
    let grayColor = #colorLiteral(red: 0.7036006266, green: 0.7036006266, blue: 0.7036006266, alpha: 1)
    let orangeColor = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)
    
    // MARK:- @IBOutlet
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        authNumberTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: authNumberTextField)
        
        sendButton.layer.cornerRadius = 10
        sendButton.backgroundColor = .opaqueSeparator
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK:- @IBAction func
    @IBAction func buttonTapped(_ sender: Any) {
        postTest()
//        guard let whereTogGo = API.shared.whereToGo else { return }
//
//        if whereTogGo == "phoneAuthFailed" {
//
//        } else if whereTogGo == "moveRegister" {
//
//        }
    }
    
    // MARK:- 구현 함수들
    func Output_Alert(title : String, message : String, text : String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    private func postText(key: String) {
        let url = API.shared.BASE_URL + "/checkStatus"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        guard let id = UserDefaults.standard.string(forKey: key) else { return  }
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
                        
                        // 메일 인증 true
                        if product.result {
                            
                            DispatchQueue.main.async {
                                guard let meetingListVC = self.storyboard?.instantiateViewController(identifier: "MeetingList") else {return}
                                meetingListVC.modalPresentationStyle = .fullScreen
                                self.present(meetingListVC, animated: false)
                            }
                            
                        } else {
                            // 메일 인증 X
                            DispatchQueue.main.async {
                                
                                guard let introVC = self.storyboard?.instantiateViewController(identifier: "Intro") else {return}

                                // MARK:- 여기부분을 Segue로 구현하면 더 좋다. !!!!!!!@@@@@@@@@@@@@@@ 중요 @@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!!
                                introVC.modalPresentationStyle = .fullScreen
                                self.present(introVC, animated: true)
                                self.Output_Alert(title: "알림", message: "메일 인증을 완료하세요.", text: "확인")
                                
                            }
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
    
    private func postTest() {
        let url = API.shared.BASE_URL + "/auth/number"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["phoneNumber" : API.shared.phoneNumber!, //!뺌
                      "code": authNumberTextField.text!] as Dictionary
        
        // httpBody 에 parameters 추가
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
                        let product = try decoder.decode(phoneAuth.self, from: response.data!)
                        print(product.result)

                        
                        if product.result == "phoneAuthFailed" {
                            
                            DispatchQueue.main.async {
                                self.dismiss(animated: true)
                            }
                            
                        } else if product.result == "moveRegister" {
                            DispatchQueue.main.async {
                                
                                // MARK:- 여기부분을 Segue로 구현하면 더 좋다. !!!!!!!@@@@@@@@@@@@@@@ 중요 @@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!!
                                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Register") else { return }
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true)
                            }
                        } else {
                            
                            // 이미 가입한 사람일때
                            UserDefaults.standard.set(product.result, forKey: "accountId")
                            self.postText(key: "accountId") // 메일 인증 체크
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

// MARK:- TextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= maxLength && range.length == 0 {
            return false
        }

        return true
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.count == maxLength {
                    textField.resignFirstResponder()
                    sendButton.isEnabled = true
                    sendButton.backgroundColor = orangeColor
                } else {
                    sendButton.isEnabled = false
                    sendButton.backgroundColor = .opaqueSeparator
                }
            }
        }
    }
}
