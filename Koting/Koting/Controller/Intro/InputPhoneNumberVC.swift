//
//  InputPhoneNumberVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class InputPhoneNumberVC: UIViewController {
    
    // MARK:- 변수
    let maxLength = 11
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.setDefault()
        sendButton.setDisable()
        
        phoneNumberTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneNumberTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        phoneNumberTextField.becomeFirstResponder()
    }
    
    // MARK:- @IBOulet
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK:- @IBAction func
    @IBAction func buttonTapped(_ sender: Any) {
        
            if self.phoneNumberTextField.text != "" {
                let phoneNumber = self.phoneNumberTextField.text!
                let isValid = self.isValidPhoneNumber(phoneNumber)
                
                
                DispatchQueue.global().async {
                    if isValid {
                        self.asyncPresentView(identifier: "AuthNumberCheck")
                        
                        UserAPI.shared.phoneNumber = phoneNumber
                        RequestAuthNumberAPI.shared.get(phoneNumber: phoneNumber) { result in
                            switch result {
                            case .success(let message):
                                print(message)
                                self.asyncPresentView(identifier: "AuthNumberCheck")
                                
                            case .failure(let error):
                                print(error)
//                                DispatchQueue.main.async {
//                                    self.makeAlertBox(title: "실패", message: "잠시후 다시시도 하세요.", text: "확인")
//                                }
                            }
                        }
                    } else {
                        self.makeAlertBox(title: "실패", message: "올바른 전화번호를 입력하세요.", text: "확인")
                    }
                }

            }
    }
    
    // MARK:- 구현한 함수
    
    // 전화번호 유효성 검사
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let firstIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 0)
        let forthIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
        let fifthIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 4)
        let zeroOneZero = "\(phoneNumber[firstIndex..<forthIndex])"
        let forthNumber = Int("\(phoneNumber[forthIndex..<fifthIndex])") ?? 0
        
        if zeroOneZero == "010" && forthNumber >= 2  { return true }
        
        return false
    }
}

// MARK:- UITextFieldDelegate 메소드
extension InputPhoneNumberVC: UITextFieldDelegate {
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
