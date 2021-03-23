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
        setDisable(button: sendButton)
        
        phoneNumberTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneNumberTextField)
    }
    
    let maxLength = 11
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        if phoneNumberTextField.text != "" {
            let phoneNumber = phoneNumberTextField.text!
            let isValid = isValidPhoneNumber(phoneNumber)
            
            if isValid {
                UserAPI.shared.phoneNumber = phoneNumber
                RequestPhoneAuth.shared.post()
                goToView(withIdentifier: "AuthNumberCheck", VC: self)
            } else {
                makeAlertBox(title: "실패", message: "번호를 다시 확인하세요.", text: "확인", VC: self)
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
                    setEnable(button: sendButton)
                } else {
                    setDisable(button: sendButton)
                }
            }
        }
    }
}
