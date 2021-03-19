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
                        API.shared.whereToGo = product.result
                        
                        if product.result == "phoneAuthFailed" {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true)
//                                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Intro") else { return }
//                                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//                                self.present(vc, animated: true)
                            }
                        } else if product.result == "moveRegister" {
                            DispatchQueue.main.async {
                                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Register") else { return }
                                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                                self.present(vc, animated: true)
                            }
                        } else {
                            // product.result 를 UserDefault에 저장
                        }
                        
                    } catch {
                        print(error)
                    }
//                    print(body)
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
