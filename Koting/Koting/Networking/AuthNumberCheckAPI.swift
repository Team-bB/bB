//
//  AuthNumberCheck.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import Alamofire

class AuthNumberCheck {
    
    static let shared = AuthNumberCheck()

    
    private init() {}
    
    func post(code: String) {
        let url = API.shared.BASE_URL + "/auth/number"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["phoneNumber" : UserAPI.shared.phoneNumber!, //!뺌
                      "code": code] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("\n\nPOST SUCCESS")
                
                guard let _ = response.value else { return }
                
                let decoder = JSONDecoder()
                
                do {
                    let product = try decoder.decode(PhoneAuth.self, from: response.data!)
                    let result = product.result
                    
                    UserAPI.shared.phoneAuthResult = result
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}
