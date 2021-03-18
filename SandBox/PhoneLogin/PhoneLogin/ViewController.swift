//
//  ViewController.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/09.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    // MARK:- @IBOutlet 및 변수
    let maxLength = 11
    let grayColor = #colorLiteral(red: 0.7036006266, green: 0.7036006266, blue: 0.7036006266, alpha: 1)
    let orangeColor = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    // MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneNumberTextField)
        
        sendButton.layer.cornerRadius = 10
        sendButton.backgroundColor = .opaqueSeparator
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK:- IBAction 함수
    @IBAction func btnTapped(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }

        if checkPhoneNumber(phoneNumber) {
            API.shared.phoneNumber = phoneNumber
            postTest()
        } else {
            Output_Alert(title: "실패", message: "번호를 다시 확인하세요.", text: "확인")
        }
    }
    
    
    // MARK:- 전화번호 유효성 검사
    func checkPhoneNumber(_ phoneNumber: String) -> Bool {
        let firstIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 0)
        let forthIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
        let fifthIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 4)
        let zeroOneZero = "\(phoneNumber[firstIndex..<forthIndex])"
        let forthNumber = Int("\(phoneNumber[forthIndex..<fifthIndex])") ?? 0
        
        if zeroOneZero == "010" && forthNumber >= 2  { return true }
        
        return false
    }
    
    // MARK:- Alamofire
    private func postTest() {
        let url = API.shared.BASE_URL + "/auth"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["phoneNumber": API.shared.phoneNumber!] as Dictionary
        
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
                debugPrint(response)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    // MARK:- Alter function
    func Output_Alert(title : String, message : String, text : String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
}

// MARK:- TextField
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= maxLength && range.length == 0{
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

