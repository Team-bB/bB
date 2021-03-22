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
    
    // MARK:- @IBAction
    @IBAction func startButtonTapped(_ sender: Any) {
        
        if UserAPI.shared.accountIdCheck == false {
            
            goToView(withIdentifier: "PhoneAuth", VC: self)
            
        } else {
            
            if UserAPI.shared.mailCheck {
                goToView(withIdentifier: "MeetingList", VC: self, animation: false)
            } else {
                makeAlertBox(title: "알림", message: "메일 인증을 완료하세요.", text: "확인", VC: self)
            }
        }
    }
    
    // MARK:- 구현 함수
    private func autoLogin() {
        
        DispatchQueue.global().async {
            
            // 유저 디폴트 O 메일 인증 O -> 미팅리스트
            if self.checkAccountId() {
                
                MailAuthCheck.shared.post()
                let isChecked = UserAPI.shared.mailCheck
                
                if isChecked {
                    goToView(withIdentifier: "MeetingList", VC: self, animation: false)
                }
            } else { return }
        }

    }
    
    private func checkAccountId() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: "accountId") else { return false }
        
        UserAPI.shared.accountIdCheck = true
        
        return true
    }
}
