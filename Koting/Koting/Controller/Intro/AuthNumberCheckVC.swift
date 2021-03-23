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
        setDisable(button: sendButton)
        authNumberTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: authNumberTextField)
      
    }
    
    let maxLength = 4

    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    @IBAction func buttonTapped(_ sender: Any) {
        
        AuthNumberCheck.shared.post(code: authNumberTextField.text!)
        
        if UserAPI.shared.phoneAuthResult == "phoneAuthFailed" {
            dismissView(self: self)
        } else if UserAPI.shared.phoneAuthResult == "moveRegister" {
            goToView(withIdentifier: "Register", VC: self)
        } else {
            // UserAPI.shared.phoneAuthResult 가 accountId일때 처리하기
            MailAuthCheck.shared.post()
            
            if UserAPI.shared.mailCheck {
                goToView(withIdentifier: "MeetingList", VC: self)
            } else {
                goToView(withIdentifier: "Intro", VC: self)
                DispatchQueue.main.async {
//                    makeAlertBox(title: "알림", message: "메일 인증을 완료하세요.", text: "학인", VC: self)
                }
            }
        }
        
    }
}

// MARK:- TextFieldDelegate
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
                    setEnable(button: sendButton)
                } else {
                    setDisable(button: sendButton)
                }
            }
        }
    }
}
