//
//  AuthNumberCheckVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import NVActivityIndicatorView

class AuthNumberCheckVC: UIViewController {
    // MARK:- 변수
    let maxLength = 4
    var indicator: NVActivityIndicatorView!
    var myInfo: Owner?
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator = NVActivityIndicatorView(
                    frame: CGRect(
                        origin: CGPoint(x: view.center.x - 50, y: view.center.y - 50),
                        size: CGSize(width: 100, height: 100)
                    ),
                    type: .circleStrokeSpin,
                    color: UIColor.gray,
                    padding: 0
                )
        self.view.addSubview(self.indicator)
        
        sendButton.setDefault()
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
        self.indicator.startAnimating()
        AuthNumberCheckAPI.shared.get(code: authNumberTextField.text!) { [weak self] result in
            
            guard let self = self else { return }
            
            let failed = "phoneAuthFailed"
            let register = "moveRegister"
            
            switch result {
            case .success(let message):
                if message.result == failed {
                    // MARK:- 여기서 알러트 띄우고 하던가 진동을 울리게 해야함.
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                    }
                    self.asyncDismissView()
                } else if message.result == register {
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                    }
                    self.asyncPresentView(identifier: "Register")
                } else {
                    
                    guard let myInfo = message.myInfo else { return }

                    UserDefaults.standard.set(message.result, forKey: "accountId")
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(myInfo), forKey:"myInfo")
                    
                    MailAuthCheckAPI.shared.post() { [weak self] result in
                        
                        guard let strongSelf = self else { return }
                        
                        switch result {
                        case .success(let mailAuth):
                            
                            let authCheck = mailAuth.result
                            
                            UserDefaults.standard.set(authCheck, forKey: "mailAuthChecked")
                            
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
                    self.indicator.stopAnimating()
                    self.makeAlertBox(title: "실패", message: "잠시후 다시시도 하세요.", text: "확인")
                }
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
