//
//  AuthNumberCheckAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import Alamofire

class AuthNumberCheckAPI {
    
    static let shared = AuthNumberCheckAPI()

    private init() {}
    
    func post(code: String, completion: @escaping (Result<PhoneAuth, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/auth/number"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        guard let phoneNumber = UserAPI.shared.phoneNumber else { return }
        
        let params = ["phoneNumber" : phoneNumber, //!뺌
                      "code": code] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\nPOST SUCCESS")
                
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(PhoneAuth.self, from: result)
                    completion(.success(product))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
