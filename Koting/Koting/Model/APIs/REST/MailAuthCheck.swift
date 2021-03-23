//
//  MailAuthCheck.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import Alamofire

class MailAuthCheck {
    
    static let shared = MailAuthCheck()

    
    private init() {}
    
    func post() {
        let url = API.shared.BASE_URL + "/checkStatus"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        guard let accountId = UserDefaults.standard.string(forKey: "account_id") else { return }
        let params = ["account_id" : accountId] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("\n\nPOST SUCCESS")
                if let _ = response.value {
                    let decoder = JSONDecoder()
                    do {
                        let product = try decoder.decode(MailAuth.self, from: response.data!)
                        
                        print(product.result)
                        
                        UserAPI.shared.mailCheck = product.result
                        
                        // 메일 인증 true면 보낸디
                    } catch {
                        print(error)
                    }
                }
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}
