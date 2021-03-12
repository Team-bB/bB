//
//  ViewController.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/09.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    let maxLength = 11
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneNumberTextField)
        sendButton.layer.cornerRadius = 15
        
    }
    @IBAction func btnTapped(_ sender: Any) {
        postTest()
    }
    
    func postTest() {
        let url = "http://15.165.143.51/phone/auth"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["phoneNumber": phoneNumberTextField.text] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                print(response.result)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}

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
                    sendButton.backgroundColor = .black
                } else {
                    sendButton.isEnabled = false
                    sendButton.backgroundColor = .gray
                }
            }
        }
    }
}

