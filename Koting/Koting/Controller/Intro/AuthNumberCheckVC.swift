//
//  AuthNumberCheckVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class AuthNumberCheckVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.setDefault()
        sendButton.setDisable()
        
        authNumberTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: authNumberTextField)
      
    }
    
    let maxLength = 4

    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    @IBAction func buttonTapped(_ sender: Any) {
        
        AuthNumberCheckAPI.shared.post(code: authNumberTextField.text!) { [weak self] result in
            
            guard let self = self else { return }
            
            let failed = "phoneAuthFaild"
            let register = "moveRegister"
            
            switch result {
            case .success(let message):
                if message.result == failed {
                    // MARK:- 여기서 알러트 띄우고 하던가 진동을 울리게 해야함.
                    self.asyncDismissView()
                } else if message.result == register {
                    self.asyncPresentView(identifier: "Register")
                } else {
                    UserDefaults.standard.set(message, forKey: "accountId")
                    
                    MailAuthCheckAPI.shared.post() { [weak self] result in
                        
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let mailAuth):
                            
                            let authCheck = mailAuth.result
                            if authCheck {
                                self.asyncPresentView(identifier: "MeetingList")
                            } else {
                                // MARK:- 여기서 알러트 띄우고 이동하는게 좋음.
                                self.asyncPresentView(identifier: "GettingStarted")
                            }
                            
                        case .failure(let error):
                            print("\(error)\n 이러면 codable 에러임")
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
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
