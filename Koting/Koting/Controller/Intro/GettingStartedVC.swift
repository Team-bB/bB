//
//  GettingStartedVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class GettingStartedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        autoLogin()
    }
    
    private var handler: ((Result<Any, Error>) -> Void)!
    
    // MARK:- @IBAction
    @IBAction func startButtonTapped(_ sender: Any) {
        
        if UserAPI.shared.accountIdCheck == false {
            
            self.asyncPresentView(identifier: "PhoneAuth")
            
        } else {
            MailAuthCheckAPI.shared.post() { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let mailAuth):
                    
                    let authCheck = mailAuth.result
                    if authCheck {
                        self.asyncPresentView(identifier: "MeetingList")
                    } else {
                        self.makeAlertBox(title: "알림", message: "메일 인증을 완료하세요.", text: "확인")
                    }
                case .failure(let error):
                    print("\(error)\n 이러면 codable 에러임")
                }
            }
        }
    }
    
    // MARK:- 구현 함수
    private func autoLogin() {
        
        DispatchQueue.global().async {
            
            // 유저 디폴트 O 메일 인증 O -> 미팅리스트
            if self.checkAccountId() {
                
                MailAuthCheckAPI.shared.post() { [weak self] result in
                    
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let mailAuth):
                        
                        let authCheck = mailAuth.result
                        if authCheck {
                            self.asyncPresentView(identifier: "MeetingList")
                        }
                        
                    case .failure(let error):
                        print("\(error)\n 이러면 codable 에러임")
                    }
                }
            }
        }

    }
    
    private func checkAccountId() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: "accountId") else { return false }
        
        UserAPI.shared.accountIdCheck = true
        
        return true
    }
}
