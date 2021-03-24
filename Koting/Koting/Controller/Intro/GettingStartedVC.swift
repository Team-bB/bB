//
//  GettingStartedVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class GettingStartedVC: UIViewController {
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLogin()
    }
    
    // MARK:- @IBOulet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- @IBAction func
    @IBAction func startButtonTapped(_ sender: Any) {
        
        if UserAPI.shared.accountIdCheck == false {
            
            self.asyncPresentView(identifier: "PhoneAuth")
            
        } else {
            self.setVisibleWithAnimation(self.activityIndicator, true)
            
            MailAuthCheckAPI.shared.post() { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let mailAuth):
                    
                    let authCheck = mailAuth.result
                    if authCheck {
                        DispatchQueue.main.async {
                            self.setVisibleWithAnimation(self.activityIndicator, false)
                        }
                        self.asyncPresentView(identifier: "MeetingList")
                    } else {
                        DispatchQueue.main.async {
                            self.setVisibleWithAnimation(self.activityIndicator, false)
                            self.makeAlertBox(title: "알림", message: "메일 인증을 완료하세요.", text: "확인")
                        }
                    }
                case .failure(let error):
                    print("\(error)\n 이러면 codable 에러임")
                }
            }
        }
    }
    
    // MARK:- 구현한 함수
    
    // 자동 로그인 함수
    private func autoLogin() {
        
        DispatchQueue.global().async {
            
            // 유저 디폴트 O 메일 인증 O -> 미팅리스트
            if self.checkAccountId() {
                
                self.setVisibleWithAnimation(self.activityIndicator, true)

                MailAuthCheckAPI.shared.post() { [weak self] result in
                    
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let mailAuth):
                        
                        let authCheck = mailAuth.result
                        if authCheck {
                            DispatchQueue.main.async {
                                self.setVisibleWithAnimation(self.activityIndicator, false)
                            }
                            self.asyncPresentView(identifier: "MeetingList")
                        } else {
                            DispatchQueue.main.async {
                                self.setVisibleWithAnimation(self.activityIndicator, false)
                            }
                        }
                        
                    case .failure(let error):
                        print("\(error)\n 이러면 codable 에러임")
                    }
                }
            }
        }

    }
    
    // UserDefaults에 accountId 유무를 check하는 함수
    private func checkAccountId() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: "accountId") else { return false }
        
        UserAPI.shared.accountIdCheck = true
        
        return true
    }
}
