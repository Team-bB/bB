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
    let indicator = CustomIndicator()
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        sendButton.setDisable()
        
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneNumberTextField)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    // MARK:- @IBOulet
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK:- @IBAction func
    @IBAction func buttonTapped(_ sender: Any) {
        
        indicator.startAnimating(superView: view)
        
        if self.phoneNumberTextField.text != "" {
            let phoneNumber = self.phoneNumberTextField.text!
            let isValid = self.isValidPhoneNumber(phoneNumber)
            
            if isValid {
                
                UserAPI.shared.phoneNumber = phoneNumber
                RequestAuthNumberAPI.shared.get(phoneNumber: phoneNumber) { [weak self]result in
                    guard let strongSelf = self else { return }
                    
                    switch result {
                    case .success(let message):
                        print(message)
                        
                        DispatchQueue.main.async {
                            strongSelf.indicator.stopAnimating()
                            strongSelf.performSegue(withIdentifier: "AuthNumberCheck", sender: nil)
                        }

                        
                    case .failure(let error):
                        print(error)
                        DispatchQueue.main.async {
                            strongSelf.indicator.stopAnimating()
                            strongSelf.makeAlertBox(title: "알림", message: "잠시후 다시시도 하세요.", text: "확인")
                        }
                    }
                }
            } else {
                indicator.stopAnimating()
                self.makeAlertBox(title: "실패", message: "올바른 전화번호를 입력하세요.", text: "확인")
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
