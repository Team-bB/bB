//
//  InputPhoneNumberVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class InputPhoneNumberVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.setDefault()
        sendButton.setDisable()
        
        phoneNumberTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneNumberTextField)
    }
    
    let maxLength = 11
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        
            if self.phoneNumberTextField.text != "" {
                let phoneNumber = self.phoneNumberTextField.text!
                let isValid = self.isValidPhoneNumber(phoneNumber)
                
                if isValid {
                    UserAPI.shared.phoneNumber = phoneNumber
                    RequestAuthNumberAPI.shared.post(phoneNumber: phoneNumber) { result in
                        switch result {
                        case .success(let message):
                            print(message)
                        case .failure(let error):
                            print(error)
                        }
                        self.asyncPresentView(identifier: "AuthNumberCheck")
                    }
                    
                } else {
                    self.makeAlertBox(title: "실패", message: "올바른 전화번호를 입력하세요.", text: "확인")
                }
            }
    }
    // MARK:- 전화번호 유효성 검사
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
