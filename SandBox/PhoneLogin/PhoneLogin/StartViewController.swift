//
//  StartViewController.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/19.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        autoLogin()
        // Do any additional setup after loading the view.
    }

    private func checkAccountId() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: "accountId") else { return false }
        
        return true
    }
    
    private func autoLogin() {
        
        DispatchQueue.global().async {
            
            if self.checkAccountId() {
                
                // 메일 인증 O
                DispatchQueue.main.async {
                    guard let meetingListVC = self.storyboard?.instantiateViewController(identifier: "MeetingList") else {return}
                    meetingListVC.modalPresentationStyle = .fullScreen
                    self.present(meetingListVC, animated: false)
                }
                
                // 메일 인증 X
                
            }
        }
        
    }
}
