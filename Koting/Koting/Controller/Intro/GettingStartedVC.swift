//
//  GettingStartedVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import NVActivityIndicatorView

class GettingStartedVC: UIViewController {
    
    var indicator: NVActivityIndicatorView!
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = NVActivityIndicatorView(
                    frame: CGRect(
                        origin: CGPoint(x: view.center.x - 50, y: view.center.y - 50),
                        size: CGSize(width: 100, height: 100)
                    ),
                    type: .ballBeat,
                    color: UIColor.orange,
                    padding: 0
                )
        self.view.addSubview(self.indicator)
        
    }

    // MARK:- @IBAction func
    @IBAction func startButtonTapped(_ sender: Any) {
        
        
        if checkAccountId() == false {
            
            self.asyncPresentView(identifier: "PhoneAuth")
            
        } else {
            self.indicator.startAnimating()
            MailAuthCheckAPI.shared.post() { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let mailAuth):
                    
                    let authCheck = mailAuth.result
                    
                    UserDefaults.standard.set(authCheck, forKey: "mailAuthChecked")
                    
                    if authCheck {
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.performSegue(withIdentifier: "MeetingList", sender: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.makeAlertBox(title: "알림", message: "메일 인증을 완료하세요.", text: "확인")
                        }
                    }
                case .failure(let error):
                    self.indicator.stopAnimating()
                    print("\(error)\n 이러면 codable 에러임")
                }
            }
        }
    }
    
    // MARK:- 구현한 함수
    // UserDefaults에 accountId 유무를 check하는 함수
    private func checkAccountId() -> Bool {
        guard let _ = UserDefaults.standard.string(forKey: "accountId") else { return false }
        return true
    }
}
