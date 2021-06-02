//
//  AuthNumberCheckVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth

class AuthNumberCheckVC: UIViewController {
    // MARK:- 변수
    let maxLength = 4
    let indicator = CustomIndicator()
    var myInfo: Owner?
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.setDisable()
        
        authNumberTextField.becomeFirstResponder()
        authNumberTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: authNumberTextField)
      
    }
    
    // MARK:- @IBOulet
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK:- @IBAction func
    @IBAction func buttonTapped(_ sender: Any) {
        
        indicator.startAnimating(superView: view)
        AuthNumberCheckAPI.shared.get(code: authNumberTextField.text!) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            let failed = "phoneAuthFailed"
            let register = "moveRegister"
            
            switch result {
            case .success(let message):
                if message.result == failed {
                    // MARK:- 여기서 알러트 띄우고 하던가 진동을 울리게 해야함.
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "실패", message: "인증번호가 일치하지 않습니다.\n다시시도 바랍니다.", text: "확인") { _ in
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                } else if message.result == register {
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                    }
                    strongSelf.asyncPresentView(identifier: "Register")
                } else {
                    
                    guard let myInfo = message.myInfo, let email = message.email else { return }

                    UserDefaults.standard.set(message.result, forKey: "accountId")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(myInfo), forKey:"myInfo")
                    
                    MailAuthCheckAPI.shared.post() {result in
                        
                        switch result {
                        case .success(let mailAuth):
                            
                            let authCheck = mailAuth.result
                            
                            UserDefaults.standard.set(authCheck, forKey: "mailAuthChecked")
                            strongSelf.loginFirebaseUser(email: email)
                            
                            UpdateDeviceTokenAPI.shared.put() { result in
                                switch result {
                                
                                case .success(let finalResult):
                                    if finalResult.result == "true" {
                                        if authCheck {
                                            DispatchQueue.main.async {
                                                strongSelf.indicator.stopAnimating()
                                                strongSelf.performSegue(withIdentifier: "MeetingList", sender: nil)
                                            }
                                        } else {
                                            // MARK:- 여기서 알러트 띄우고 이동하는게 좋음.
                                            DispatchQueue.main.async {
                                                strongSelf.indicator.stopAnimating()
                                            }
                                            strongSelf.asyncPresentView(identifier: "GettingStarted")
                                        }
                                    }
                                case .failure(_):
                                    print("에러 발생")
                                    DispatchQueue.main.async {
                                        strongSelf.indicator.stopAnimating()
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            DispatchQueue.main.async {
                                strongSelf.indicator.stopAnimating()
                            }
                            print("\(error)\n 이러면 codable 에러임")
                        }
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    strongSelf.indicator.stopAnimating()
                    strongSelf.makeAlertBox(title: "실패", message: "잠시후 다시시도 하세요.", text: "확인")
                }
            }
        }
    }
    
    private func loginFirebaseUser(email: String, password: String = "koting0000") {
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authReulst, error in

            guard let result = authReulst, error == nil else {
                print("❌ 로그인 에러발생: \(errSecMissingAttributeKey) ❌")
                return
            }
            
            let user = result.user
            print("✅ 로그인 유저: \(user) ✅")
        }
        
    }
}

// MARK:- UITextFieldDelegate 메소드
extension AuthNumberCheckVC: UITextFieldDelegate {
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
                    sendButton.setEnable()
                } else {
                    sendButton.setDisable()
                }
            }
        }
    }
}
